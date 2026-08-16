#include <stdio.h>

int main(){
    int x = 42;
    int *p = &x;
    printf("Direccion de x: %p Valor: %d\n", (void*) &x, x);            // &x = dirección de x, x = valor de x
    printf("Direccion de p: %p Valor: %p\n", (void*) &p, (void*) p);    // &p = dirección de p, p = valor de p = dirección de x
    printf("Valor de lo que apunta p: %d\n", *p);                       // *p = Valor apuntado por p = valor de x
}