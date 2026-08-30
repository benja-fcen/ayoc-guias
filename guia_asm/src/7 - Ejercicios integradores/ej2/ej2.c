#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ej2.h"

/**
 * Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - es_indice_ordenado
 */
bool EJERCICIO_2A_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - contarCombustibleAsignado
 */
bool EJERCICIO_2B_HECHO = true;

/**
 * Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
 *
 * Funciones a implementar:
 *   - modificarUnidad
 */
bool EJERCICIO_2C_HECHO = true;

/**
 * OPCIONAL: implementar en C
 */
void optimizar(mapa_t mapa, attackunit_t *compartida,
               uint32_t (*fun_hash)(attackunit_t *)) {
  for (int i = 0; i < 255; i++)
    for (int j = 0; j < 255; j++) {
      attackunit_t *cUnit = mapa[i][j];
      if (cUnit) {
        if (fun_hash(cUnit) == fun_hash(compartida)) {
          mapa[i][j] = compartida;
          compartida->references++;
          cUnit->references--;
        }
        if (cUnit->references == 0)
          free(cUnit);
      }
    }
}

/**
 * OPCIONAL: implementar en C
 */
uint32_t contarCombustibleAsignado(mapa_t mapa,
                                   uint16_t (*fun_combustible)(char *)) {
  uint32_t total = 0;
  for (int i = 0; i < 255; i++)
    for (int j = 0; j < 255; j++) {
      attackunit_t *cUnit = mapa[i][j];
      if (!cUnit)
        continue;
      total += cUnit->combustible - fun_combustible(cUnit->clase);
    }
  return total;
}

/**
 * OPCIONAL: implementar en C
 */
void modificarUnidad(mapa_t mapa, uint8_t x, uint8_t y,
                     void (*fun_modificar)(attackunit_t *)) {
  attackunit_t *cUnit = mapa[x][y];
  if (!cUnit)
    return;
  if (cUnit->references == 1)
    fun_modificar(cUnit);
  else {
    attackunit_t *nUnit = malloc(sizeof(attackunit_t));
    memcpy(nUnit, cUnit, sizeof(attackunit_t));
    nUnit->references = 1;
    cUnit->references--;
    mapa[x][y] = nUnit;
    fun_modificar(nUnit);
  }
}
