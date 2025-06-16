EXTERNAL_DIR=$(CURDIR)/external
BUILD_DIR=$(CURDIR)/build
REPORT_DIR=$(CURDIR)/reports


ANTLR_VERSION=4.13.2
ANTLR_JAR=antlr-$(ANTLR_VERSION)-complete.jar
ANTLR_URL=https://www.antlr.org/download/$(ANTLR_JAR)

GRAMMAR_FILES=$(wildcard src/grammar/*.g4)

# Check if we're on Windows
ifeq ($(OS),Windows_NT)
    DETECTED_OS := Windows
    # Windows specific settings
    RM_CMD=if exist "$1" rmdir /s /q "$1"
    RMFILE_CMD=if exist "$1" del /f /q "$1"
    MKDIR_CMD=if not exist "$1" mkdir "$1"
    COPY_CMD=xcopy /y /e "$1" "$2"
    SEP=\\
    # Use powershell to download ANTLR
    DOWNLOAD_CMD=powershell -Command "Invoke-WebRequest -Uri $(ANTLR_URL) -OutFile $(EXTERNAL_DIR)/$(ANTLR_JAR)"
    # No colors on Windows CMD by default
    RED=
    GREEN=
    YELLOW=
    BLUE=
    RESET=
else
    DETECTED_OS := $(shell uname -s)
    # Unix-like systems
    RM_CMD=rm -rf "$1"
    RMFILE_CMD=rm -f "$1"
    MKDIR_CMD=mkdir -p "$1"
    COPY_CMD=cp -r "$1" "$2"
    SEP=/
    # Use curl on Unix-like systems
    DOWNLOAD_CMD=curl -o $(EXTERNAL_DIR)/$(ANTLR_JAR) $(ANTLR_URL) || wget -O $(EXTERNAL_DIR)/$(ANTLR_JAR) $(ANTLR_URL)
    # ANSI color codes (only for Unix-like terminals)
    RED=\033[31m
    GREEN=\033[32m
    YELLOW=\033[33m
    BLUE=\033[34m
    RESET=\033[0m
endif

.PHONY: setup build clean clean-cache test-lexer test-parser

setup:
	$(call MKDIR_CMD,$(EXTERNAL_DIR))
	@echo "$(BLUE)Setting up external directory at $(EXTERNAL_DIR)$(RESET)"
	@echo "$(YELLOW)Checking if Java is installed...$(RESET)"
ifeq ($(OS),Windows_NT)
	@java -version > nul 2>&1 || (echo "$(RED)Error: Java is not installed. Please install Java and try again.$(RESET)" && exit 1)
else
	@java -version > /dev/null 2>&1 || (echo "$(RED)Error: Java is not installed. Please install Java and try again.$(RESET)" && exit 1)
endif
	@echo "$(GREEN)Java is installed.$(RESET)"
	@echo "$(YELLOW)Downloading ANTLR version $(ANTLR_VERSION)...$(RESET)"
	@echo "$(BLUE)This may take a moment...$(RESET)"
	@$(DOWNLOAD_CMD)
	@echo "$(GREEN)ANTLR downloaded to $(EXTERNAL_DIR)/$(ANTLR_JAR)$(RESET)"
	@echo "$(YELLOW)Installing Python dependencies...$(RESET)"
	@python -m pip install -r requirements.txt --user 2>/dev/null || \
	 python3 -m pip install -r requirements.txt --user 2>/dev/null || \
	 python -m pip install -r requirements.txt --break-system-packages 2>/dev/null || \
	 python3 -m pip install -r requirements.txt --break-system-packages 2>/dev/null || \
	 (echo "$(RED)Failed to install Python dependencies. Please install manually:$(RESET)" && \
	  echo "$(YELLOW)Try: python -m pip install -r requirements.txt --user$(RESET)" && \
	  echo "$(YELLOW)Or: python -m pip install -r requirements.txt --break-system-packages$(RESET)")
	@echo "$(GREEN)Python dependencies installed.$(RESET)"

build: $(GRAMMAR_FILES) $(EXTERNAL_DIR)/$(ANTLR_JAR)
	$(call MKDIR_CMD,$(BUILD_DIR))
	$(call MKDIR_CMD,$(BUILD_DIR)/src)
	$(call MKDIR_CMD,$(BUILD_DIR)/src/grammar)
	@echo "$(YELLOW)Compiling ANTLR grammar files...$(RESET)"
	java -jar $(EXTERNAL_DIR)/$(ANTLR_JAR) -Dlanguage=Python3 -visitor -no-listener -o $(BUILD_DIR) $(GRAMMAR_FILES)
	@echo "$(GREEN)ANTLR grammar files compiled to build/$(RESET)"
	@echo "$(YELLOW)Creating __init__.py files...$(RESET)"
ifeq ($(OS),Windows_NT)
	@type nul > "$(BUILD_DIR)/__init__.py"
	@type nul > "$(BUILD_DIR)/src/__init__.py"
	@type nul > "$(BUILD_DIR)/src/grammar/__init__.py"
else
	@touch "$(BUILD_DIR)/__init__.py"
	@touch "$(BUILD_DIR)/src/__init__.py"
	@touch "$(BUILD_DIR)/src/grammar/__init__.py"
endif
	@echo "$(YELLOW)Copying Python files from src/grammar/ to build/src/grammar/$(RESET)"
ifeq ($(OS),Windows_NT)
	@if exist "$(CURDIR)\src\grammar\lexererr.py" copy "$(CURDIR)\src\grammar\lexererr.py" "$(CURDIR)\build\src\grammar\" /Y
else
	@cp -f "$(CURDIR)/src/grammar/lexererr.py" "$(CURDIR)/build/src/grammar/" 2>/dev/null || :
endif
	@echo "$(GREEN)ANTLR grammar files compiled to build/$(RESET)"

clean-cache:
	@echo "$(YELLOW)Cleaning Python cache files...$(RESET)"
	find $(CURDIR) -type d -name "__pycache__" -exec rm -rf {} +
	find $(CURDIR) -type f -name "*.pyc" -exec rm -f {} +
	find $(CURDIR) -type d -name ".pytest_cache" -exec rm -rf {} +
	@echo "$(GREEN)Python cache files cleaned.$(RESET)"

clean-reports:
	@echo "$(YELLOW)Cleaning reports directory...$(RESET)"
	$(call RM_CMD,$(REPORT_DIR))
	@echo "$(GREEN)Reports directory cleaned.$(RESET)"

clean:
	$(call RM_CMD,$(BUILD_DIR))
	$(call RM_CMD,$(EXTERNAL_DIR))
	@echo "$(GREEN)Cleaned build and external directories.$(RESET)"
	@find $(CURDIR) -type d -name "__pycache__" -exec rm -rf {} +
	@find $(CURDIR) -type f -name "*.pyc" -exec rm -f {} +
	@find $(CURDIR) -type d -name ".pytest_cache" -exec rm -rf {} +
	@echo "$(GREEN)Cleaned Python cache files recursively.$(RESET)"

test-lexer: clean setup build
	@echo "$(YELLOW)Running lexer tests...$(RESET)"
	$(call RM_CMD,$(REPORT_DIR)/lexer)
	$(call MKDIR_CMD,$(REPORT_DIR))
	@PYTHONPATH=$(CURDIR) pytest tests/test_lexer.py --html=$(REPORT_DIR)/lexer/index.html --timeout=3 --self-contained-html || true
	@echo "$(GREEN)Lexer tests completed. Reports generated at $(REPORT_DIR)/lexer/index.html$(RESET)"
	@$(MAKE) clean-cache

test-parser: clean setup build
	@echo "$(YELLOW)Running parser tests...$(RESET)"
	$(call RM_CMD,$(REPORT_DIR)/parser)
	$(call MKDIR_CMD,$(REPORT_DIR))
	@PYTHONPATH=$(CURDIR) pytest tests/test_parser.py --html=$(REPORT_DIR)/parser/index.html --timeout=3 --self-contained-html || true
	@echo "$(GREEN)Parser tests completed. Reports generated at $(REPORT_DIR)/parser/index.html$(RESET)"
	@$(MAKE) clean-cache

