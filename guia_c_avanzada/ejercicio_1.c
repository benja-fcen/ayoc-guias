
#include <stdio.h>

typedef struct {
    char nombre[50];
    int vida;
    double ataque;
    double defensa;
} mounstruo_t;

int main() {
    mounstruo_t monstruos[3] = {
        {"Goblin", 10, 1.0, 0.0},
        {"Ogro", 25, 12, 2.5},
        {"Zombi", 15, 2.0, 1.5}};
    for(int i = 0; i < 3; i++) {
        printf("Mounstruo #%d: %s\n"
        "Vida: %d\n"
        "Ataque: %.2lf\n"
        "Defensa: %.2lf\n",
        i + 1, monstruos[i].nombre,
        monstruos[i].vida,
        monstruos[i].ataque,
        monstruos[i].defensa);
    }
    return 0;
}