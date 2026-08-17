#include <stdio.h>
#include <stdint.h>

uint16_t *secuencia(uint16_t n){
    uint16_t arr[n];
    for(uint16_t i = 0; i < n; i++)
        arr[i] = i;
    return arr;
}

int main(){
    uint16_t *arr = secuencia(10);
    printf("%d\n", arr[0]); // -> Segfault, arr apunta a una dirección de memoria no válida
    return 0;
}