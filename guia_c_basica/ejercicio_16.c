#include <stdio.h>
#define FELIZ 0
#define TRISTE 1

void ser_feliz(int estado);
void print_estado(int estado);

int main() {
	int estado = TRISTE; // automatic duration. Block scope
	ser_feliz(estado);
	print_estado(estado); // -> triste
}

void ser_feliz(int estado) {
	estado = FELIZ;		// Modifica la COPIA de la variable que le pasamos por parametro, la varible original no se ve afectada
}

void print_estado(int estado) {
	printf("Estoy %s\n", estado == FELIZ ? "feliz" : "triste");
}