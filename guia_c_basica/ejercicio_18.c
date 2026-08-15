#include <stdio.h>
#define FELIZ 0
#define TRISTE 1
int estado = TRISTE; // static duration. File scope

void alcoholizar();
void print_estado();

int main(){
	print_estado(); // -> triste
	alcoholizar();	// la variable "estado" pasa a "FELIZ", pues cantidad es < 3, "cantidad" vale 1.
	print_estado();	// -> feliz
	alcoholizar();alcoholizar();alcoholizar(); // La variable estatica "cantidad" vale 4 luego de la última llamdada, "estado" pasa a valer "TRISTE"
	print_estado(); // -> triste
}
void alcoholizar(){
	static int cantidad = 0; // static duration. block scope
	cantidad++;
	if(cantidad < 3){
		estado = FELIZ;
	}else{
		estado = TRISTE;
	}
}
void print_estado(){
	printf("Estoy %s\n", estado == FELIZ ? "feliz" : "triste");
}