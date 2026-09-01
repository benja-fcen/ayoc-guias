#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej4a.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - init_fantastruco_dir
 */
bool EJERCICIO_1A_HECHO = true;

// OPCIONAL: implementar en C
void init_fantastruco_dir(fantastruco_t* card) { 
  directory_t dir = malloc(sizeof(directory_entry_t*) * 2);
  dir[0] = create_dir_entry("sleep", sleep);
  dir[1] = create_dir_entry("wakeup", wakeup);
  card->__dir = dir;
  card->__archetype = NULL;
  card->__dir_entries = 2;
}

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - summon_fantastruco
 */
bool EJERCICIO_1B_HECHO = true;

// OPCIONAL: implementar en C
fantastruco_t* summon_fantastruco() {
  fantastruco_t* carta = malloc(sizeof(fantastruco_t));
  carta->face_up = true;
  init_fantastruco_dir(carta);
  return carta;
}
