#include <iostream>
#include <fstream>
using namespace std;

#include "Lexer.hpp"


int main(int argc, char *argv[])
{
  string palabra;
	if(argc <2){
		cout <<"Faltan argumentos"<<endl;
		exit(EXIT_FAILURE);
	}
  //Se abre el archivo a analizar
	filebuf fb;
	fb.open(string(argv[1]), ios::in);
	if(!fb.is_open()){
		cout<<"El archivo no existe o no tienes permisos"<<endl;
		exit(EXIT_FAILURE);
	}

	istream is(&fb);
  Lexer lexer(&is);
  
//Recorremos todo el archivo
//Reconocimiento de tokens e impresiÃ³n de las palabras
int token;
  while((token = lexer.yylex()) != 0){
    string palabra = lexer.YYText();
    cout<<"Token <"<<token<<"), "<<palabra<<">"<<endl;
  }

  cout << "Se encontraron " << lexer.getNumErrors() << " errores.\n";

  if(in_comment){
    printf("Algun comentario no estÃ¡ cerrado correctamente");
  }

  fb.close();
  
	return 0;
}
