#include <stdio.h>

int main() {
	int i = 5;
	int j = 10;
	printf("El operador preincremento ++i, primero incrementa i y luego devuelve su valor:\n"
		"Si tenemos que i vale %d", i);
	printf(" vamos a tener que ++i vale %d", ++i);
	printf(" luego de la operación i vale %d\n", i);
	printf("El operador postincremento j++, primero devuelve el valor de j y luego lo incrementa:\n"
		"Si tenemos que j vale %d", j);
	printf(" vamos a tener que j++ vale %d", j++);
	printf(" luego de la operación j vale %d\n", j);

}