# Generated from src/grammar/BKIT.g4 by ANTLR 4.13.2
from antlr4 import *
from io import StringIO
import sys
if sys.version_info[1] > 5:
    from typing import TextIO
else:
    from typing.io import TextIO


try:
    from .lexererr import *
except ImportError:
    from lexererr import *


def serializedATN():
    return [
        4,0,6,36,6,-1,2,0,7,0,2,1,7,1,2,2,7,2,2,3,7,3,2,4,7,4,2,5,7,5,1,
        0,4,0,15,8,0,11,0,12,0,16,1,1,1,1,1,2,1,2,1,3,1,3,1,3,1,3,1,4,4,
        4,28,8,4,11,4,12,4,29,1,4,1,4,1,5,1,5,1,5,0,0,6,1,1,3,2,5,3,7,4,
        9,5,11,6,1,0,2,1,0,97,122,3,0,9,10,13,13,32,32,37,0,1,1,0,0,0,0,
        3,1,0,0,0,0,5,1,0,0,0,0,7,1,0,0,0,0,9,1,0,0,0,0,11,1,0,0,0,1,14,
        1,0,0,0,3,18,1,0,0,0,5,20,1,0,0,0,7,22,1,0,0,0,9,27,1,0,0,0,11,33,
        1,0,0,0,13,15,7,0,0,0,14,13,1,0,0,0,15,16,1,0,0,0,16,14,1,0,0,0,
        16,17,1,0,0,0,17,2,1,0,0,0,18,19,5,59,0,0,19,4,1,0,0,0,20,21,5,58,
        0,0,21,6,1,0,0,0,22,23,5,86,0,0,23,24,5,97,0,0,24,25,5,114,0,0,25,
        8,1,0,0,0,26,28,7,1,0,0,27,26,1,0,0,0,28,29,1,0,0,0,29,27,1,0,0,
        0,29,30,1,0,0,0,30,31,1,0,0,0,31,32,6,4,0,0,32,10,1,0,0,0,33,34,
        9,0,0,0,34,35,6,5,1,0,35,12,1,0,0,0,3,0,16,29,2,6,0,0,1,5,0
    ]

class BKITLexer(Lexer):

    atn = ATNDeserializer().deserialize(serializedATN())

    decisionsToDFA = [ DFA(ds, i) for i, ds in enumerate(atn.decisionToState) ]

    ID = 1
    SEMI = 2
    COLON = 3
    VAR = 4
    WS = 5
    ERROR_CHAR = 6

    channelNames = [ u"DEFAULT_TOKEN_CHANNEL", u"HIDDEN" ]

    modeNames = [ "DEFAULT_MODE" ]

    literalNames = [ "<INVALID>",
            "';'", "':'", "'Var'" ]

    symbolicNames = [ "<INVALID>",
            "ID", "SEMI", "COLON", "VAR", "WS", "ERROR_CHAR" ]

    ruleNames = [ "ID", "SEMI", "COLON", "VAR", "WS", "ERROR_CHAR" ]

    grammarFileName = "BKIT.g4"

    def __init__(self, input=None, output:TextIO = sys.stdout):
        super().__init__(input, output)
        self.checkVersion("4.13.2")
        self._interp = LexerATNSimulator(self, self.atn, self.decisionsToDFA, PredictionContextCache())
        self._actions = None
        self._predicates = None


    def action(self, localctx:RuleContext, ruleIndex:int, actionIndex:int):
        if self._actions is None:
            actions = dict()
            actions[5] = self.ERROR_CHAR_action 
            self._actions = actions
        action = self._actions.get(ruleIndex, None)
        if action is not None:
            action(localctx, actionIndex)
        else:
            raise Exception("No registered action for:" + str(ruleIndex))


    def ERROR_CHAR_action(self, localctx:RuleContext , actionIndex:int):
        if actionIndex == 0:
            raise ErrorToken(self.text)
     


