extern malloc
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

; Completar las definiciones (serán revisadas por ABI enforcer):
USUARIO_ID_OFFSET EQU 0
USUARIO_NIVEL_OFFSET EQU 4
USUARIO_SIZE EQU 8

CASO_CATEGORIA_OFFSET EQU 0
CASO_ESTADO_OFFSET EQU 4
CASO_USUARIO_OFFSET EQU 8
CASO_SIZE EQU 16

SEGMENTACION_CASOS0_OFFSET EQU 0
SEGMENTACION_CASOS1_OFFSET EQU 8
SEGMENTACION_CASOS2_OFFSET EQU 16
SEGMENTACION_SIZE EQU 24

ESTADISTICAS_CLT_OFFSET EQU 0
ESTADISTICAS_RBO_OFFSET EQU 1
ESTADISTICAS_KSC_OFFSET EQU 2
ESTADISTICAS_KDT_OFFSET EQU 3
ESTADISTICAS_ESTADO0_OFFSET EQU 4
ESTADISTICAS_ESTADO1_OFFSET EQU 5
ESTADISTICAS_ESTADO2_OFFSET EQU 6
ESTADISTICAS_SIZE EQU 7

contar_casos_por_nivel:
  ; rdi = arreglo_casos
  ; esi = largo
  ; rdx = contadores
  test esi, esi
  .f0:
    jz .return
    mov rcx, [rdi + CASO_USUARIO_OFFSET]
    mov ecx, [rcx + USUARIO_NIVEL_OFFSET]
    add dword [rdx + 4 * rcx], CASO_SIZE
    add rdi, CASO_SIZE
    dec esi
    jmp .f0
  .return:
  ret

inicializar_nivel:
  ; rdi = contador[X] = cantidad_de_casos * sizeof(caso_t)
  ; rsi = segmentacion_t*
  ; rdx = segmentacion_casoX_offset
  push rbp
  mov rbp, rsp

  mov qword [rsi + rdx], 0    ; rsi->casos_nivel_x = NULL
  test rdi, rdi         ; if(!rsi)
  jz .return            ;   return
  push rsi              ;
  push rdx              ;
  call malloc           ; malloc(rsi)
  pop rdx
  pop rsi
  mov [rsi + rdx], rax  ; segmentacion_t->casos_nivel_x = malloc(sizeof(caso_t * contador[x]))

  .return:
  mov rsp, rbp
  pop rbp
  ret

inicializar_segmentacion:


;segmentacion_t* segmentar_casos(caso_t* arreglo_casos, int largo)
global segmentar_casos
segmentar_casos:
  push rbp
  mov rbp, rsp
  sub rsp, 16
  mov dword [rbp - 4], 0
  mov qword [rbp - 12], 0
  push r12                                    ; arreglo_casos
  push r13                                    ; largo
  push r14                                    ; segmentacion_t res
  push r15                                    ; contadores[3]
  mov r12, rdi                                ; arreglo_casos
  mov r13d, esi                               ; largo
  lea rdx, [rbp - 12]                         ; contadores[3] = {0};
  call contar_casos_por_nivel
  mov rdi, SEGMENTACION_SIZE
  call malloc                                 ; malloc(sizeof(segmentacion_t))
  mov r14, rax                                ; r14 = res = malloc(sizeof(segmentacion_t))
  lea r15, [rbp - 12]                         ; r15 = contadores
  
  ; Inicialización de segmentacion_t res:
  mov edi, [r15 + 4 * 0]                      ; rdi = contadores[0] * sizeof(caso_t)
  mov rsi, r14                                ; rsi = res
  mov rdx, SEGMENTACION_CASOS0_OFFSET;        ; rdx = SEGMENTACION_CASOS0_OFFSET
  call inicializar_nivel                      ; inicializar_nivel(contadores[0] * sizeof(caso_t), res, SEGMETACION_CASOS0_OFFSET)
  mov edi, [r15 + 4 * 1]                      ; rdi = contadores[1] * sizeof(caso_t)
  mov rsi, r14                                ; rsi = res
  mov rdx, SEGMENTACION_CASOS1_OFFSET         ; rdx = SEGMENTACION_CASOS1_OFFSET
  call inicializar_nivel                      ; inicializar_nivel(contadores[0] * sizeof(caso_t), res, SEGMETACION_CASOS0_OFFSET) 
  mov edi, [r15 + 4 * 2]                      ; rdi = contadores[2] * sizeof(caso_t)
  mov rsi, r14                                ; rsi = res
  mov rdx, SEGMENTACION_CASOS2_OFFSET         ; rdx = SEGMENTACION_CASOS2_OFFSET
  call inicializar_nivel                      ; inicializar_nivel(contadores[0] * sizeof(caso_t), res, SEGMETACION_CASOS0_OFFSET) 
  
  mov rdi, [r14 + SEGMENTACION_CASOS0_OFFSET] ; res->casos_nivel_0
  mov rsi, [r14 + SEGMENTACION_CASOS1_OFFSET] ; res->casos_nivel_1
  mov rdx, [r14 + SEGMENTACION_CASOS2_OFFSET] ; res->casos_nivel_2
  test r13, r13
  jmp .c0
  .l0:
    mov r8, [r12 + CASO_USUARIO_OFFSET]       ; r8 = arreglo_casos[i].usuario
    mov r9d, [r8 + USUARIO_NIVEL_OFFSET]      ; r9 = arreglo_casos[i].usuario->nivel
    cmp r9, 1
    jb .case0
    je .case1
    .case2:
      mov [rdx], r12                          ; res->casos_nivel_0[j] = arreglo_casos[i]
      add rdx, CASO_SIZE                      ; j++
      jmp .continue                           ; break
    .case1:
      mov [rsi], r12                          ; res->casos_nivel_1[k] = arreglo_casos[i]
      add rsi, CASO_SIZE                      ; k++
      jmp .continue                           ; break
    .case0:
      mov [rdi], r12                          ; res->casos_nivel_0[l] = arreglo_casos[i]
      add rdi, CASO_SIZE                      ; l++
    .continue:
    add r12, CASO_SIZE                        ; i++
    dec r13
  .c0:
    jnz .l0 
  mov rax, r14
  pop r15
  pop r14
  pop r13
  pop r12
  mov rsp, rbp
  pop rbp
  ret



  


