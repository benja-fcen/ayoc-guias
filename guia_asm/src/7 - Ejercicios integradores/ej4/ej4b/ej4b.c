#include "ej4b.h"

#include <string.h>

// OPCIONAL: implementar en C
void invocar_habilidad(void* carta_generica, char* habilidad) {
	card_t* carta = carta_generica;
  if(!carta) return;
  if(carta->__dir_entries == 0) invocar_habilidad(carta->__archetype, habilidad);
  bool contieneHabilidad = false;
  int i = 0;
  do
    contieneHabilidad = !strncmp(carta->__dir[i]->ability_name, habilidad, 10);
  while(!contieneHabilidad && ++i < carta->__dir_entries);
  if(contieneHabilidad)
    ((ability_function_t*)carta->__dir[i]->ability_ptr)(carta_generica);
  else
    invocar_habilidad(carta->__archetype, habilidad);
}
