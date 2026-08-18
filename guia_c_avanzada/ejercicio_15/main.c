#include <stdio.h>
#include "list.h"

int main() {
    list_t* l = listNew(TypeFAT32);
    fat32_t* f1 = new_fat32();
    fat32_t* f2 = new_fat32();
    fat32_t* f3 = new_fat32();
    listAddFirst(l, f1);
    listAddFirst(l, f2);
    listAddFirst(l, f3);
    printf("Contenido de la lista:\n");
    printf("{%u, %u, %u}\n", *((fat32_t*) listGet(l, 0)), *((fat32_t*) listGet(l, 1)), *((fat32_t*) listGet(l, 2)));
    swap(l, 0, 1);
    printf("Contenido de la lista luego de hacer el primer swap:\n");
    printf("{%u, %u, %u}\n", *((fat32_t*) listGet(l, 0)), *((fat32_t*) listGet(l, 1)), *((fat32_t*) listGet(l, 2)));
    swap(l, 1, 2);
    printf("Contenido de la lista luego de hacer el segundo swap:\n");
    printf("{%u, %u, %u}\n", *((fat32_t*) listGet(l, 0)), *((fat32_t*) listGet(l, 1)), *((fat32_t*) listGet(l, 2)));
    swap(l, 0, 2);
    printf("Contenido de la lista luego de hacer el tercer swap:\n");
    printf("{%u, %u, %u}\n", *((fat32_t*) listGet(l, 0)), *((fat32_t*) listGet(l, 1)), *((fat32_t*) listGet(l, 2)));
    listDelete(l);
    rm_fat32(f1);
    rm_fat32(f2);
    rm_fat32(f3);
    return 0;
}