#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NAME_LEN 50

typedef struct persona_s {
    char nombre[NAME_LEN+1];
    int edad;
    struct persona_s* hijo;
} persona_t;

persona_t *crearPersona(const char *nombre, const int edad) {
    persona_t *nuevaPersona = malloc(sizeof(persona_t));
    strncpy(nuevaPersona->nombre, nombre, NAME_LEN);
    nuevaPersona->edad = edad;
    return nuevaPersona;
}

void imprimir_persona(const persona_t *persona) {
    printf("Nombre: %s\n"
            "edad: %d\n"
            "tiene hijos: %s\n",
            persona->nombre, persona->edad, persona->hijo ? "Si" : "No");
}

void eliminarPersona(persona_t *persona) {
    if(persona->hijo) eliminarPersona(persona->hijo);
    free(persona);
}

int main() {
    persona_t *jp = crearPersona("Juan Perez", 42);
    persona_t *jpjr = crearPersona("Juan Perez Jr", 21);
    jp->hijo = jpjr;
    imprimir_persona(jp);
    imprimir_persona(jpjr);
    eliminarPersona(jp);
    eliminarPersona(jpjr);
    return 0;
}