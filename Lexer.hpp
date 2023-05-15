#ifndef __LEXER_HPP__
#define __LEXER_HPP__

#if !defined(yyFlexLexerOnce)
#include <FlexLexer.h>
#endif

#include <string>
using namespace std;

#include "Tokens.hpp"

class Lexer : public yyFlexLexer
{
public:
    Lexer(std::istream *in) : yyFlexLexer(in){
        num_errors = 0;
        line = 1;
    }
    ~Lexer() = default;
    using FlexLexer::yylex;
    virtual int yylex();

    int getLine();
    int getNumErrors();
    
private:
    int line;
    int num_errors;
};

#endif // !__LEXER_HPP__
