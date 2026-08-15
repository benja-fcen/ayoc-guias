#include <stdio.h>

int a = 45;

int main() {
	{
	int b = 2;
	printf("Si ambas variables tienen nombres diferentes "
	"no se da la situación de sahdowing, por lo tanto, podemos "
	"podemos imprimir a: %d y b: %d\n", a, b);
	}
	{
	int a = 2;
	printf("Si ambas variables, la local y la global, tienen "
	"el mismo nombre, la variable local enmascara a la variable global. "
	"En este caso tenemos una situación de shadowing, el valor de a es: %d\n", a);
	}
}