%{
    #include <stdio.h>
    #include <string.h>

    void yyerror(char *mensaje);
    int yylex();    
    void nuevaTemp(char *s);
%}

%union{
    char cadena[50];
}

%token SUMA RESTA MULT DIV
%token <cadena>ENTERO
%token EOL

%type <cadena> expresion
%type <cadena> termino
%type <cadena> factor

%%
inicio      :   expresion EOL           { printf("----------\n"); }
            ;

expresion   :   expresion SUMA termino  { nuevaTemp($$); printf("%s=%s+%s\n",$$,$1,$3);  }
            |   expresion RESTA termino { nuevaTemp($$); printf("%s=%s-%s\n",$$,$1,$3);  }
            |   termino                 {   }
            ;

termino     :   termino MULT factor     { nuevaTemp($$); printf("%s=%s*%s\n",$$,$1,$3);  }
            |   termino DIV factor      { nuevaTemp($$); printf("%s=%s/%s\n",$$,$1,$3);  }
            |   factor                  {   }
            ;

factor      :   ENTERO                  {   }
            ;

%%

void nuevaTemp(char *s) {
    static int actual = 1;
    sprintf(s, "t%d", actual++);
} 

void yyerror(char *mensaje) {
    fprintf(stderr, "Error: %s\n", mensaje);
}

int main() {
    yyparse();
    return 0;
}
