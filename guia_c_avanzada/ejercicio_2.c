
#include <stdio.h>
#include <string.h>

typedef struct {
    char nombre[50];
    int vida;
    double ataque;
    double defensa;
} monstruo_t;

monstruo_t evolution(monstruo_t monstruo) {
    monstruo_t nuevo_monstruo;
    strcpy(nuevo_monstruo.nombre, monstruo.nombre);
    nuevo_monstruo.vida = monstruo.vida + 10;
    nuevo_monstruo.ataque = monstruo.ataque + 10;
    nuevo_monstruo.defensa = monstruo.defensa;
    return nuevo_monstruo;
}

void imprimir_monstruo(const monstruo_t *monstruo) { // Se puede hacer const monstruo_t *monstruo para evitar copiar
    printf("Monstruo : %s\n"
        "Vida: %d\n"
        "Ataque: %.2lf\n"
        "Defensa: %.2lf\n", 
        monstruo->nombre,
        monstruo->vida,
        monstruo->ataque,
        monstruo->defensa);
}

int main() {
    monstruo_t monstruos[3] = {
        {"Goblin", 10, 1.0, 0.0},
        {"Ogro", 25, 12, 2.5},
        {"Zombi", 15, 2.0, 1.5}};
    imprimir_monstruo(&monstruos[2]);
    printf("Evolucionando Zombi...\n");
    monstruo_t nuevo_monstruo = evolution(monstruos[2]);
    imprimir_monstruo(&nuevo_monstruo);
    return 0;
}