from antlr4 import *
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


class Parser:
    def __init__(self, input_string):
        self.input_stream = InputStream(input_string)
        self.lexer = HLangLexer(self.input_stream)
        self.token_stream = CommonTokenStream(self.lexer)
        self.parser = parser_class(self.token_stream)

    def parse(self):
        try:
            self.parser.program()  # Assuming 'program' is the entry point of your grammar
            return "success"
        except Exception as e:
            return str(e)
