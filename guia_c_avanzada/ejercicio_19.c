#include <stdio.h>
int main() {
int matrix[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}};

    // p apunta al int en la fila 0, columna 0
    int *p = &matrix[0][0];
    // ¿qué es reshape?
    int (*reshape)[2] = (int (*)[2]) p; // Reshape es un puntero a un arreglo de 2 elementos
    // Más especificamente, reinterprea la memoria en p como un arreglo de dos elementos.
    /*reshape = {{1,2}
                {3,4},
                {5,6},
                {7,8},
                {9,10},
                {11,12}} */
    printf("%d\n", p[3]); // Qué imprime esta lı́nea? --> 4. Esto es *(p + 3)
    printf("%d\n", reshape[1][1]); // Qué imprime esta lı́nea? --> 4. Esto es *(reshape + 1 * 2 + 1)
}