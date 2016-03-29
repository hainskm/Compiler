
grammar token;

options
{
	language = Java;
}

/* Program */

start				: program EOF ;
//start				: start program | .+?;

program				: WHITESPACE? PROGRAM id BEGIN pgm_body END COMMENT?;
id					: IDENTIFIER ;
pgm_body			: decl func_declarations ;
decl				: string_decl decl
					| var_decl decl
					| empty ;
empty				: WHITESPACE? ;

/* Global String Declaration */
string_decl			: STRING id OP_ASSIGN str OP_SEMIC COMMENT?;
str					: STRINGLITERAL ;

/* Variable Declaration */
var_decl			: var_type id_list OP_SEMIC COMMENT?;
var_type			: FLOAT
					| INT ;
any_type			: var_type
					| VOID ;
id_list				: id id_tail ;
id_tail				: OP_COMMA id id_tail
					| empty ;

/* Function Parameter List */
param_decl_list		: param_decl param_decl_tail
					| empty ;
param_decl			: var_type id ;
param_decl_tail		: OP_COMMA param_decl param_decl_tail
					| empty ;

/* Function Declaration */
func_declarations	: func_decl func_declarations
					| empty ;
func_decl			: FUNCTION any_type id OP_LP param_decl_list OP_RP BEGIN func_body END COMMENT?;
func_body			: decl stmt_list ;

/* Statement List */
stmt_list			: stmt stmt_list
					|empty ;
stmt				: base_stmt
					| if_stmt
					| while_stmt ;
base_stmt			: assign_stmt
					| read_stmt
					| write_stmt
					| return_stmt ;

/* Basic Statement */
assign_stmt			: assign_expr OP_SEMIC COMMENT?;
assign_expr			: id OP_ASSIGN expr ;
read_stmt			: READ OP_LP id_list OP_RP OP_SEMIC COMMENT?;
write_stmt			: WRITE OP_LP id_list OP_RP OP_SEMIC COMMENT?;
return_stmt			: RETURN expr OP_SEMIC ;

/* Expressions */
expr				: expr_prefix factor; // factor expr_postfix; 
expr_prefix			: expr_prefix factor addop // addop factor expr_postfix 
					| empty ;
factor				: factor_prefix postfix_expr ; // prefix_expr factor_postfix;
factor_prefix		: factor_prefix postfix_expr mulop //mulop prefix_expr factor_postfix
					| empty ;
postfix_expr			: primary
					| call_expr ;
call_expr			: id OP_LP expr_list OP_RP ;
expr_list			: expr expr_list_tail
					| empty ;
expr_list_tail		: OP_COMMA expr expr_list_tail
					| empty ;
primary				: OP_LP expr OP_RP
					| id
					| INTLITERAL
					| FLOATLITERAL ;
addop				: OP_PLUS
					| OP_MINUS ;
mulop				: OP_STAR
					| OP_SLASH ;

/* Complex Statements and Condition */
if_stmt			: IF OP_LP cond OP_RP decl stmt_list else_part ENDIF COMMENT?;
else_part		: ELSE decl stmt_list
				| empty ;
cond			: expr comop expr ;
comop			: OP_CLT
				| OP_CGT
				| OP_EQUALS
				| OP_NOT_EQUALS
				| OP_CLTE
				| OP_CGTE ;

/* While Statement */
while_stmt			: WHILE OP_LP cond OP_RP decl stmt_list ENDWHILE COMMENT?;

// We should only need our print functions in the "{}" appearances to identify tokens.

/*Tokens/Keywords */
PROGRAM			: 'PROGRAM' WHITESPACE? ;
BEGIN			: 'BEGIN' WHITESPACE? ;
END				: 'END' WHITESPACE? ;
FUNCTION		: 'FUNCTION' WHITESPACE? ;
READ			: 'READ' WHITESPACE? ;
WRITE			: 'WRITE' WHITESPACE? ;
IF				: 'IF' WHITESPACE? ;
ELSE			: 'ELSE' WHITESPACE? ;
ENDIF			: 'ENDIF' WHITESPACE? ;
WHILE			: 'WHILE' WHITESPACE? ;
ENDWHILE		: 'ENDWHILE' WHITESPACE? ;
CONTINUE		: 'CONTINUE' WHITESPACE? ;
BREAK			: 'BREAK' WHITESPACE? ;
RETURN			: 'RETURN' WHITESPACE? ;
INT				: 'INT' WHITESPACE? ;
VOID			: 'VOID' WHITESPACE? ;
STRING			: 'STRING' WHITESPACE? ;
FLOAT			: 'FLOAT' WHITESPACE? ;

/*Operators */
OP_ASSIGN		: ':=' WHITESPACE? ;
OP_PLUS			: '+' WHITESPACE? ;
OP_MINUS		: '-' WHITESPACE? ;
OP_STAR			: '*' WHITESPACE? ;
OP_SLASH		: '/' WHITESPACE? ;
OP_EQUALS		: '=' WHITESPACE? ;
OP_NOT_EQUALS	: '!=' WHITESPACE? ;
OP_CLT			: '<' WHITESPACE? ;
OP_CGT			: '>' WHITESPACE? ;
OP_LP			: '(' WHITESPACE? ;
OP_RP			: ')' WHITESPACE? ;
OP_SEMIC		: ';' WHITESPACE? ;
OP_COMMA		: ',' WHITESPACE? ;
OP_CLTE			: '<=' WHITESPACE? ;
OP_CGTE			: '>=' WHITESPACE? ;

INTLITERAL		: [0-9]+ WHITESPACE? ;
FLOATLITERAL 	: [0-9]* '.' [0-9]+ WHITESPACE? ;
STRINGLITERAL	: '"' ~'"'* '"' WHITESPACE? ;
COMMENT			: '--' ~[\r\n]* [\r\n] WHITESPACE? COMMENT?;
WHITESPACE		: (' '|'\t'|'\r'|'\n')+ -> skip ;   //\t is tab, \r is char return ' '\t\r\n
IDENTIFIER		: [a-zA-Z][a-zA-Z0-9]* WHITESPACE? ;
