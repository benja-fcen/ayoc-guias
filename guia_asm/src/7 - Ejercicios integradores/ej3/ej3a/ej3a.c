#include "../ejs.h"

// Función auxiliar para contar casos por nivel
void contar_casos_por_nivel(caso_t *arreglo_casos, int largo, int *contadores) {
  for (int i = 0; i < largo; i++)
    contadores[arreglo_casos[i].usuario->nivel]++;
}

segmentacion_t *segmentar_casos(caso_t *arreglo_casos, int largo) {
  int contadores[3] = {0};
  contar_casos_por_nivel(arreglo_casos, largo, contadores);
  segmentacion_t *res = malloc(sizeof(segmentacion_t));
  res->casos_nivel_0 = contadores[0] ? malloc(sizeof(caso_t) * contadores[0]) : NULL;
  res->casos_nivel_1 = contadores[1] ? malloc(sizeof(caso_t) * contadores[1]) : NULL;
  res->casos_nivel_2 = contadores[2] ? malloc(sizeof(caso_t) * contadores[2]) : NULL;
  for (int i = 0, j = 0, k = 0, l = 0; i < largo; i++) {
    switch (arreglo_casos[i].usuario->nivel) {
    case 0: res->casos_nivel_0[j++] = arreglo_casos[i]; break;
    case 1: res->casos_nivel_1[k++] = arreglo_casos[i]; break;
    case 2: res->casos_nivel_2[l++] = arreglo_casos[i]; break;
    }
  }
  return res;
}
