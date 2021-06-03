%{
    #include <stdio.h>
    #include <stdlib.h>    
    
    int extern linha;
    int extern coluna;
    int extern yyleng;
    char extern *yytext;
    FILE *f;

    int yylex(void);
    int yyerror(char *error_msg){
        printf("%s (%i, %i) = %s\n",error_msg,linha,coluna-yyleng, yytext);
        exit(1);
    }
    
    // codificação em assembly
    void montar_codigo_inicial(){
	    f = fopen("out.s","w+");
	    fprintf(f, ".text\n");
	    fprintf(f, "    .global _start\n\n");
    	fprintf(f, "_start:\n\n");
    }

    void montar_codigo_final(){
	    fclose(f);

	    printf("Arquivo \"out.s\" gerado.\n\n");
    }

    void montar_codigo_retorno(int numero){
        fprintf(f, "# Codigo de retorno\n");
	    fprintf(f, "    popq    %%rbx\n");
	    fprintf(f, "    movq    $1, %%rax\n");
	    fprintf(f, "    int     $0x80\n\n");
    }

    void montar_codigo_empilhamento(int num){
        fprintf(f, "#Cód para empilhar o numero %i\n", num);
        fprintf(f, "    pushq    $%i\n\n", num); // empilhamento na pilha
	    
    }
    void declarar_variavel_int(){
                
    }
    void montar_codigo_operacao(char op){
        fprintf(f,"#Código para operacao de %c\n", op);
	    fprintf(f, "    popq    %%rax\n");
        fprintf(f, "    popq    %%rbx\n");

        if(op == '+'){
            fprintf(f, "    addq    %%rax, %%rbx\n");
        }
        
        if(op == '-'){
            fprintf(f, "    subq    %%rax, %%rbx\n");
        }
        
        fprintf(f, "    pushq    %%rbx\n\n");
	}
%}

%token INT MAIN RETURN ABRE_PARENTESES FECHA_PARENTESES ABRE_CHAVES FECHA_CHAVES 
%token PONTO_E_VIRGULA NUM ID
%left '+' '-'  //realiza o calculo da esquerda para a direita  



%%
programa: INT MAIN ABRE_PARENTESES FECHA_PARENTESES 
          ABRE_CHAVES{montar_codigo_inicial();} 
          corpo FECHA_CHAVES{montar_codigo_final();
          }
        ;

corpo: INT declaracao RETURN expr PONTO_E_VIRGULA{montar_codigo_retorno($2) ;} corpo
       |
       ;
declaracao:
expr: expr '+' expr {montar_codigo_operacao('+');}
    | expr '-' expr {montar_codigo_operacao('-');}
    | NUM           {montar_codigo_empilhamento($1);}
    ; 
%%

int main(){
    yyparse();
	printf("Entrada reconhecida.\n");	
	return 0;
}


