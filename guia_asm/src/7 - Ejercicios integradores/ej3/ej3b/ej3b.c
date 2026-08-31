#include "../ejs.h"
#include <string.h>

bool resolver_caso_por_categoria(caso_t* caso, char *categoria) {
  bool res = !strncmp(categoria, "CLT", 4) || !strncmp(categoria, "RBO", 4);
  if(res)
    caso->estado = 2;
  return res;
}

bool resolver_caso_por_funcion(caso_t* caso, uint16_t resultado_funcion) {
  if(resultado_funcion)
    caso->estado = 1;
  return resultado_funcion || resolver_caso_por_categoria(caso, caso->categoria);
}

bool resolver_caso_por_nivel(caso_t* caso, funcionCierraCasos_t* funcion, uint32_t nivel) {
  return nivel > 0 && nivel < 3 && resolver_caso_por_funcion(caso, funcion(caso));
}

bool resolver_caso(caso_t* caso, funcionCierraCasos_t* funcion) {
  return resolver_caso_por_nivel(caso, funcion, caso->usuario->nivel);
}

void resolver_automaticamente(funcionCierraCasos_t* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo){
  for(int i = 0, j = 0; i < largo; i++)
    if(!resolver_caso(&arreglo_casos[i], funcion))
      casos_a_revisar[j] = arreglo_casos[i];
}

