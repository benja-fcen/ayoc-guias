#include <stdio.h>
#include <stdint.h>
int main(){
    uint8_t *x = (uint8_t*) 0xF0;
    int8_t *y = (int8_t*) 0xF6;
    printf("Dir de x: %p Valor: %d\n", (void*) x, *x);
    printf("Dir de y: %p Valor: %d\n", (void*) y, *y);
    //Devolverá:
    // Dir de x: 0xF0 Valor: 255
    // Dir de y: 0xF6 Valor: -128
    /* 'x' es un entero de 8 bits y debe poder guardar el valor 255, necesitará
    tener todos sus bits en 1 para poder representarlo.
    Representa un entero de 1 byte sin signo.

    'y' también es un entero de 8 bits, pero debe guardar el número -99, por lo que
    debe ser un entero con signo y usará su bit de signo para indicar el signo del valor que guarda.
    Representa un entero de 1 byte con signo.
    */
}