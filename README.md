# HLang Compiler Project

A compiler implementation for HLang, a simple programming language, using the ANTLR4 parser generator.

## Overview

This is a mini project for the Principle of Programming Languages course (CO3005) that implements a simple compiler for HLang, a custom programming language. The project focuses on the fundamental concepts of compiler construction, including lexical analysis and parsing using ANTLR4 (ANother Tool for Language Recognition).

## Project Structure

```
.
├── Makefile              # Build automation
├── README.md             # This file
├── requirements.txt      # Python dependencies
├── assets/               # Static assets (CSS for reports)
├── build/                # Generated parser and lexer code
├── external/             # External dependencies (ANTLR jar)
├── reports/              # Test reports
│   ├── lexer/            # Lexer test reports
│   └── parser/           # Parser test reports
├── src/                  # Source code
│   └── grammar/          # Grammar definitions
│       ├── HLang.g4      # ANTLR4 grammar file
│       └── lexererr.py   # Lexer error handling
└── tests/                # Test files
    ├── test_lexer.py     # Lexer tests
    ├── test_parser.py    # Parser tests
    └── utils.py          # Testing utilities
```

## Setup and Usage

### Prerequisites

- Python 3
- Java Runtime Environment (for ANTLR4)

### Installation

1. Clone this repository:
   ```
   git clone <repository-url>
   cd project
   ```

2. Set up the environment and download dependencies:
   ```
   make setup
   ```

### Building the Compiler

```
make build
```

This command:
1. Compiles the ANTLR grammar files to Python code
2. Configures the build directory structure
3. Copies necessary files

### Running Tests

To test the lexer:
```
make test-lexer
```

To test the parser:
```
make test-parser
```

Test reports are generated in HTML format in the `reports/` directory.

### Cleaning up

To clean Python cache files:
```
make clean-cache
```

To clean the entire build and external directories:
```
make clean
```

## Error Handling

The lexer handles three types of errors:
- `ErrorToken`: Invalid tokens
- `UncloseString`: Unclosed string literals
- `IllegalEscape`: Illegal escape sequences in strings

## Development

### Extending the Grammar

To extend the language grammar:
1. Modify `src/grammar/HLang.g4`
2. Run `make build` to regenerate parser code
3. Add appropriate tests in `tests/`

### Adding New Tests

- Lexer tests: Add test functions to `tests/test_lexer.py`
- Parser tests: Add test functions to `tests/test_parser.py`

## License

This project is licensed to the Department of Computer Science, Faculty of Computer Science and Engineering - Ho Chi Minh City University of Technology (VNU-HCM).

