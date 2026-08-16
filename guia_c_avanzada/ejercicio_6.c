#include <stdio.h>
#include <stdint.h>

int main(){
    int8_t memoria[9] = {-1, 31, 42, 0, 55, 67, -128, 127, -99}; // puse -1 en lugar de 255 para que no salte el warning 
    uint8_t *x = (uint8_t*) &memoria[0];
    int8_t *y = &memoria[8];
    printf("Dir de x: %p Valor: %d\n", (void*) x, *x);
    printf("Dir de y: %p Valor: %d\n", (void*) y, *y);
}