%{
#include <iostream>
#include <string>
using namespace std;

#include "Lexer.hpp"

#undef YY_DECL
#define YY_DECL int Lexer::yylex()

int num_errors = 0; //Variable para contar errores

int in_comment = 0; //Variable para error de cierre de comentarios
int column = 0;
int line = 0;

%}

%x COMMENT
%x BLOCK_COMMENT

%option c++
%option outfile="Lexer.cpp"
%option yyclass="Lexer"
%option yylineno

vocalesSA [aeiouAEIOU]
vocalesCA [áéíóúÁÉÍÓÚ]
letra  [a-zA-Z]
enies [ñÑ]
simbEsp [_$]
digito [0-9]
dieresis [äëïöüÄËÏÖÜ] 
espacios [ \a\b\f\n\r\t\v\\"]
id {letra}({letra}|{vocalesSA}|{vocalesCA}|{simbEsp}|{dieresis}|{enies})*
espacio [\t\v\r]

lenteros [0-9]+(_?[0-9]+)*

lflotantes (({lenteros}+\.{lenteros}*|\.{lenteros}+)([eE][+-]?{lenteros}+)?|{lenteros}+[eE][+-]?{lenteros}+)([fF]|[lL])?

cadena "[^"\n]*"|'[^'\n]*'

runas '({letra}|{vocalesCA}|{enies}|{espacios})+'

%%
<INITIAL>.    { ++column; }
<INITIAL>\n   { ++line; column = 0; }

<INITIAL>  {id}            {return ID;}
<INITIAL>  {lenteros}+     {return INTEGER;}
<INITIAL>  {lflotantes}+   {return FLOAT;}
<INITIAL>  {cadena}        {return STRING;}
<INITIAL>  {runas}+        {return RUNE;}


<INITIAL>"//".* {
    // Ignorar comentarios de una línea
}

<INITIAL>"/*" {
    BEGIN(BLOCK_COMMENT);
}

<BLOCK_COMMENT>"*/" {
    BEGIN(INITIAL);
}

<BLOCK_COMMENT>.|\n {
    // Ignorar caracteres dentro de comentarios de bloque
}

<BLOCK_COMMENT><<EOF>> {
    // Error: comentario de bloque no cerrado
    std::cerr << "Error léxico en la línea " << yylineno << ": comentario de bloque no cerrado\n"; 
    ++num_errors;
    if(num_errors >= 5) exit(1);
}

[ \t\r\n]+     {
    // Ignorar espacios en blanco
}



"/*"        {in_comment=1;}
"*/"        {in_comment=0;}

\n          { ++line; column = 0; }
.           { ++column; }

<INITIAL>. { 
    std::cerr << "Error léxico en la línea " << yylineno << ", columna " << column << ": caracter no reconocido '" << yytext << "'\n"; 
    ++num_errors;
    if(num_errors >= 5) exit(1);
}


%%
/*Sección de código de usuario*/
int Lexer::yywrap(){
    return 1;
}


int Lexer::getLine(){
    return line;
}

int Lexer::getNumErrors(){
    return num_errors;
}

void yyerror(const char *msg) {
    std::cerr << msg << std::endl;
}
