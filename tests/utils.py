from antlr4 import *
from antlr4.error.ErrorListener import ErrorListener
import importlib
lang = "BKIT"
lexer_name = lang + "Lexer"
parser_name = lang + "Parser"
lexer_path = f"build.src.grammar.{lexer_name}"
parser_path = f"build.src.grammar.{parser_name}"
lexer_module = importlib.import_module(lexer_path)
parser_module = importlib.import_module(parser_path)
lexer_class = getattr(lexer_module, lexer_name)
parser_class = getattr(parser_module, parser_name)

#from build.src.grammar.HLangLexer import HLangLexer
#from build.src.grammar.HLangParser import HLangParser


class Tokenizer:
    def __init__(self, input_string):
        self.input_stream = InputStream(input_string)
        self.lexer = lexer_class(self.input_stream)

    def get_tokens(self):
        tokens = []
        token = self.lexer.nextToken()
        while token.type != Token.EOF:
            tokens.append(token.text)
            try:
                token = self.lexer.nextToken()
            except Exception as e:
                tokens.append(str(e))
                return tokens
        return tokens + ["EOF"]

    def get_tokens_as_string(self):
        tokens = []
        token = self.lexer.nextToken()
        while token.type != Token.EOF:
            tokens.append(token.text)
            try:
                token = self.lexer.nextToken()
            except Exception as e:
                tokens.append(str(e))
                return ",".join(tokens)
        return ",".join(tokens + ["EOF"])

class MyErrorListener(ErrorListener):
    def __init__(self):
        super(MyErrorListener, self).__init__()
        self.has_error = False
        self.msg = ""

    def syntaxError(self, recognizer, offendingSymbol, line, column, msg, e):
        self.has_error = True
        self.msg = f"Syntax Error at line {line}:{column} - {msg}"


class Parser:
    def __init__(self, input_string):
        self.input_stream = InputStream(input_string)
        self.lexer = lexer_class(self.input_stream)
        self.token_stream = CommonTokenStream(self.lexer)
        self.parser = parser_class(self.token_stream)
        self.error_listener = MyErrorListener()
        self.parser.removeErrorListeners()  
        self.parser.addErrorListener(self.error_listener)

    def parse(self):
        self.parser.program()
        if self.error_listener.has_error:
            return self.error_listener.msg
        return "success"
