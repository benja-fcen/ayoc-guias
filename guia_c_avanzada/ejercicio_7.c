#include <stdio.h>

void swap(int a, int b) {
    int tmp = a;
    a = b;
    b = tmp;
}

int main() {
    int x = 10, y = 20;
    swap(x, y);
    printf("x: %d, y: %d\n", x, y);
}

/* En caso de usar swap(int a, int b) ocurre que se
pasan los valores de x e y por copia, luego se realiza
lo modificación sobre las copias de estos valores dejando
a x e y intactos.
*/
