#include <stdlib.h>
#include "list.h"

list_t* listNew(type_t t) {
    list_t* l = malloc(sizeof(list_t));
    l->type = t; // l->type es equivalente a (*l).type
    l->size = 0;
    l->first = NULL;
    l->last = NULL;
    return l;
}

void listAddFirst(list_t* l, void* data) {
    node_t* n = malloc(sizeof(node_t));
    switch(l->type) {
        case TypeFAT32:
            n->data = (void*) copy_fat32((fat32_t*) data);
            break;
        case TypeEXT4:
            n->data = (void*) copy_ext4((ext4_t*) data);
            break;
        case TypeNTFS:
            n->data = (void*) copy_ntfs((ntfs_t*) data);
            break;
}
    n->next = l->first;
    n->prev = NULL;
    if(l->size == 0) l->last = n;
    if(l->first) l->first->prev = n;
    l->first = n;
    l->size++;
}

void printList(list_t *l) {
    if(!l->first) {printf("{ }\n"); return;}
    printf("{ ");
    for(node_t *n = l->first; n ; n = n->next) {
        if(n->next) printf("%u, ", *((uint32_t*) n->data));
        else printf("%u }\n", *((uint32_t*) n->data));
    }
}

void printListReversed(list_t *l) {
    if(!l->first) {printf("{ }\n"); return;}
    printf("{ ");
    for(node_t *n = l->last; n ; n = n->prev) {
        if(n->prev) printf("%u, ", *((uint32_t*) n->data));
        else printf("%u }\n", *((uint32_t*) n->data));
    }
}

void listAddLast(list_t *l, void *data)
{
    node_t* n = malloc(sizeof(node_t));
    switch(l->type) {
        case TypeFAT32:
            n->data = (void*) copy_fat32((fat32_t*) data);
            break;
        case TypeEXT4:
            n->data = (void*) copy_ext4((ext4_t*) data);
            break;
        case TypeNTFS:
            n->data = (void*) copy_ntfs((ntfs_t*) data);
            break;
}
    if(l->size == 0) l->first = n;
    if(l->last) l->last->next = n;
    n->prev = l->last;
    l->last = n;
    n->next = NULL;
    l->size++;
}

//se asume: i < l->size
void* listGet(list_t* l, uint8_t i){
    node_t* n = l->first;
    for(uint8_t j = 0; j < i; j++)
        n = n->next;
    return n->data;
}

//se asume: i < l->size
void* listRemove(list_t* l, uint8_t i){
    node_t* tmp = NULL;
    void* data = NULL;
    if(i == 0){
        data = l->first->data;
        tmp = l->first;
        l->first = l->first->next;
    }
    else{
        node_t* n = l->first;
        for(uint8_t j = 0; j < i - 1; j++)
            n = n->next;
        data = n->next->data;
        tmp = n->next;
        n->next = n->next->next;
    }
    free(tmp);
    l->size--;
    return data;
}

void listDelete(list_t* l){
    node_t* n = l->first;
    while(n){
        node_t* tmp = n;
        n = n->next;
        switch(l->type) {
            case TypeFAT32:
                rm_fat32((fat32_t*) tmp->data);
                break;
            case TypeEXT4:
                rm_ext4((ext4_t*) tmp->data);
                break;
            case TypeNTFS:
                rm_ntfs((ntfs_t*) tmp->data);
                break;
        }
        free(tmp);
    }
    free(l);
}

// Aclaración: Todo este quilombo se puede simplificar usando punteros a punteros
// simplemente usando una función con la pinta swapNodes(node_t **nodeA, node_t **nodeB)
// Luego simplemente intercambiamos a lo que apuntan (o a lo que refieren) nodeA y nodeB.
// Lo hice de esta forma porque a esta altura de la guía todavía no se anuncian los punteros a punteros.
void swap(list_t *l, int i, int j) {
    if(l->size < 1 || i == j) return;
    node_t *currA = l->first, 
        *prevA = NULL, 
        *nextA = NULL,
        *currB = l->first, 
        *prevB = NULL,
        *nextB = NULL;
    for(int k = 0; k < i; k++)
        currA = currA->next;
    for(int k = 0; k < j; k++)
        currB = currB->next;
    prevA = currA->prev;
    prevB = currB->prev;
    nextA = currA->next;
    nextB = currB->next;
    if(prevA) prevA->next = currB;
    if(prevB) prevB->next = currA;
    if(nextA) nextA->prev = currB;
    if(nextB) nextB->prev = currA;
    if(i == 0) l->first = currB;
    if(j == 0) l->first = currA;
    if(i == l->size - 1) l->last = currB;
    if(j == l->size - 1) l->last = currA;
    node_t *tmp = currA->next;
    currA->next = currB->next;
    currB->next = tmp;
    tmp = currA->prev;
    currA->prev = currB->prev;
    currB->prev = tmp;
}
