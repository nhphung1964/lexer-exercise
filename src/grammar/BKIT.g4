grammar BKIT;

@lexer::header {
try:
    from .lexererr import *
except ImportError:
    from lexererr import *
}

options{
	language=Python3;
}

program  : VAR COLON ID SEMI EOF ;

ID: [a-z][a-z0-9]* ;

SEMI: ';' ;

COLON: ':' ;

VAR: 'Var' ;

WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines


ERROR_CHAR: .  {raise ErrorToken(self.text)};
