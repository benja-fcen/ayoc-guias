#include <stdio.h>

int main() {
    char *str1 = "Hola";
    char str2[] = "Hola";
    printf("%s\n", str1);
    printf("%s\n", str2);
    return 0;
}
/* str2[] es el string "Hola" y, por copiar todos los elementos 
del string literal "Hola", cada uno de sus elementos puede modificarse.
str1, en cambio, es un puntero al string literal "Hola", modificar
alguno de los elementos de str1, es equivalente a intentar modificar
los caracteres de un array de caracteres constante, como resultado el 
sistema operativo arrojará un error.
*/