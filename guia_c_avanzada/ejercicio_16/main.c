#include <stdio.h>
#include "list.h"

int main() {
    list_t* l = listNew(TypeFAT32);
    fat32_t* f1 = new_fat32();
    fat32_t* f2 = new_fat32();
    fat32_t* f3 = new_fat32();
    fat32_t* f4 = new_fat32();

    listAddFirst(l, f2);
    printf("Contenido de la lista: "); printList(l);
    printf("Contenido de la lista en reversa: "); printListReversed(l);
    listAddFirst(l, f1);
    listAddLast(l, f3);
    listAddLast(l, f4);
    printf("Contenido de la lista, luego de agregar 0 al principio y el 2 y el 3 al final:\n");
    printf("Al derecho: "); printList(l);
    printf("En reversa: "); printListReversed(l);
    printf("Tamaño de la lista: %u\n", l->size);
    
    printf("Swapeamos los elementos intermedios: \n"); swap(l, 1, 2); 
    printf("Imprimiendo al derecho y al revéz...\n");
    printList(l);
    printListReversed(l);

    printf("Swapeamos el primer y el último elemento: \n"); swap(l, 0, 3); 
    printf("Imprimiendo al derecho y al revéz...\n");
    printList(l);
    printListReversed(l);

    printf("Swapeamos el primero con el segundo: \n"); swap(l, 0, 1); 
    printf("Imprimiendo al derecho y al revéz...\n");
    printList(l);
    printListReversed(l);

    printf("Swapeamos el ultimo con el anteultimo: \n"); swap(l, 2, 3); 
    printf("Imprimiendo al derecho y al revéz...\n");
    printList(l);
    printListReversed(l);


    listDelete(l);
    rm_fat32(f1);
    rm_fat32(f2);
    rm_fat32(f3);
    return 0;
}