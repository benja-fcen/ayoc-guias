#include <stdio.h>
#define FELIZ 0
#define TRISTE 1

int estado = TRISTE; // static duration. File scope

void ser_feliz();
void print_estado();

int main(){
	print_estado();	// -> triste
	ser_feliz();
	print_estado(); // -> feliz
}

void ser_feliz(){
	estado = FELIZ;	// Se modifica la variable global llamada "estado".
}

void print_estado(){
	printf("Estoy %s\n", estado == FELIZ ? "feliz" : "triste");
}