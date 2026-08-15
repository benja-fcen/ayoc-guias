#include <stdio.h>

int g = 10;

void functionA() {
	int a = 20;
	static int b = 30;
	printf("Dentro de functionA:\n");
	printf(" g = %d\n", g);
	printf(" a = %d\n", a);
	printf(" b = %d\n", b);

	// Modificación de las variables
	g += 5;
	a += 10;
	b += 5;
}

void functionB() {
	int a = 40;
	static int c = 50;
	printf("\nDentro de functionB:\n");
	printf(" g = %d\n", g);
	printf(" a = %d\n", a);
	printf(" c = %d\n", c);

	// Modificación de las variables
	g += 5;
	a += 10;
	c += 5;
}
int main() {
	printf("Dentro de main:\n");
	printf(" g = %d\n", g); // g = 10
	
	functionA(); // g = 10, a = 20, b = 30 -> Ahora g vale 15 y b vale 35
	functionB(); // g = 15, a = 40, c = 50 -> Ahora g vale 20 y c vale 55
	functionA(); // g = 20, a = 20, b = 35 -> Ahora g vale 25 y b vale 40
	functionB(); // g = 25, a = 40, c = 55 -> Ahora g vale 30 y c vale 60
	
	printf("\nFinal en main:\n");
	printf(" g = %d\n", g);	// g = 30
	
	return 0;
}