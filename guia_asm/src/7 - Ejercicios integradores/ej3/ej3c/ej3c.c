#include "../ejs.h"
#include <string.h>

void contabilizar(estadisticas_t *res, uint16_t estado, const char* categoria) {
  switch(estado) {
    case 0: res->cantidad_estado_0++; break;
    case 1: res->cantidad_estado_1++; break;
    case 2: res->cantidad_estado_2++; break;
  }
  if(!strncmp(categoria, "CLT", 4))
    res->cantidad_CLT++;
  if(!strncmp(categoria, "RBO", 4))
    res->cantidad_RBO++;
  if(!strncmp(categoria, "KSC", 4))
    res->cantidad_KSC++;
  if(!strncmp(categoria, "KDT", 4))
    res->cantidad_KDT++;
}

estadisticas_t* calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id){
  estadisticas_t *res = malloc(sizeof(estadisticas_t));
  memset(res, 0, sizeof(estadisticas_t));
  for(int i = 0; i < largo; i++) {
    const caso_t caso = arreglo_casos[i];
    const char* categoria = caso.categoria;
    uint16_t estado = caso.estado;
    uint32_t id = caso.usuario->id;
    if(!usuario_id || id == usuario_id)
      contabilizar(res, estado, categoria); // rdi, si, rdx
  }
  return res;
}

