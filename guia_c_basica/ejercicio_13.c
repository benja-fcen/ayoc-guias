#include <stdio.h>
#include <time.h>
#include <stdlib.h>

#define N (int)6e6
#define SIDES 6
int main() {
	int count[SIDES] = {0};
	srand(time(NULL)); // Cambia la seed cada vez que se corre el programa, de esta forma obtenemos resultados diferentes sin tener que recompilar
	for(int i = 0; i < N; i++)
		count[rand() % SIDES]++;
	for(int i = 0; i < SIDES; i++)
		printf("El número %d salio %d veces\n", i, count[i]);
}