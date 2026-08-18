#include <stdio.h>
#include "list.h"

int main() {
    list_t* l = listNew(TypeFAT32);
    fat32_t* f1 = new_fat32();
    fat32_t* f2 = new_fat32();
    listAddFirst(l, f1);
    printf("Contenido de la lista luego de agregar el primer elemento:\n");
    printf("Primer elemento: %u\n", *((fat32_t*) listGet(l, 0)));
    printf("Contenido de la lista luego de agregar el segundo elemento:\n");
    listAddFirst(l, f2);
    printf("Primer elemento: %u\n"
            "Segundo elemento: %u\n", *((fat32_t*) listGet(l, 0)), *((fat32_t*) listGet(l, 1)));
    listDelete(l);
    rm_fat32(f1);
    rm_fat32(f2);
    return 0;
}