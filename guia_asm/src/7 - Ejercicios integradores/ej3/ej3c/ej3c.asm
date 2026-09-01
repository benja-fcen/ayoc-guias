extern malloc
extern memset
extern strncmp
;########### SECCION DE DATOS
section .data
len: dd 4
clt: db 'CLT', 0
rbo: db 'RBO', 0
ksc: db 'KSC', 0
kdt: db 'KDT', 0
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



global calcular_estadisticas

; void contabilizar(estadisticas_t *res, uint16_t estado, const char* categoria)
; rdi = res
; si = estado
; rdx = categoria
contabilizar:
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp - 8], rdx                            ; categoria
  push r12
  mov r12, rdi                                  ; res

  cmp si, 1                                     ; switch(estado)
  jb .estado_0
  je .estado_1                                  ; case 2:
  inc byte [r12 + ESTADISTICAS_ESTADO2_OFFSET]  ;   res->cantidad_estado_2++;
  jmp .contabilizar_categoria                   ;   break;
  .estado_1:                                    ; case 1:
  inc byte [r12 + ESTADISTICAS_ESTADO1_OFFSET]  ;   res->cantidad_estado_1++;
  jmp .contabilizar_categoria                   ;   break;
  .estado_0:                                    ; case 0:
  inc byte [r12 + ESTADISTICAS_ESTADO0_OFFSET]  ;   res->cantidad_estado_0++;
  .contabilizar_categoria:                      ;   break;
  
  mov rdi, [rbp - 8]
  mov rsi, clt
  mov edx, [len]
  call strncmp                            ;
  test rax, rax                           ; if(!strncmp(categoria, "CLT", 4))
  jnz .comparar_rbo                       ;
  inc byte [r12 + ESTADISTICAS_CLT_OFFSET]     ;   res->cantidad_CLT++;
  jmp .return
 
  .comparar_rbo:
  mov rdi, [rbp - 8]
  mov rsi, rbo
  mov edx, [len]
  call strncmp
  test rax, rax                           ; else if(!strncmp(categoria, "RBO", 4))
  jnz .comparar_ksc
  inc byte [r12 + ESTADISTICAS_RBO_OFFSET]     ;   res->cantidad_RBO++;
  jmp .return

  .comparar_ksc:
  mov rdi, [rbp - 8]
  mov rsi, ksc
  mov edx, [len]
  call strncmp
  test rax, rax                           ; else if(!strncmp(categoria, "KSC", 4))
  jnz .comparar_kdt
  inc byte [r12 + ESTADISTICAS_KSC_OFFSET]     ;   res->cantidad_KSC++;
  jmp .return

  .comparar_kdt:
  mov rdi, [rbp - 8]
  mov rsi, kdt
  mov edx, [len]
  call strncmp
  test rax, rax                           ; else if(!strncmp(categoria, "KDT", 4))
  jnz .return
  inc byte [r12 + ESTADISTICAS_KDT_OFFSET]     ;   res->cantidad_KDT++;

  .return:
  pop r12
  mov rsp, rbp
  pop rbp
  ret

;void calcular_estadisticas(caso_t* arreglo_casos, int largo, uint32_t usuario_id)
; rdi = arreglo_casos
; esi = largo
; edx = usuario_id
calcular_estadisticas:
  push rbp
  mov rbp, rsp
  sub rsp, 24
  push r12
  mov r12, rdi        ; arreglo_casos
  mov [rbp - 4], esi  ; largo
  mov [rbp - 8], edx  ; usuario_id
  ;mov [rbp - 16], 0  ; res
  
  mov rdi, ESTADISTICAS_SIZE              ; rdi = sizeof(estadisticas_t)
  call malloc
  mov [rbp - 16], rax                     ; res = malloc(sizeof(estadisticas_t))
  mov rdi, [rbp - 16]                     ; rdi = res
  mov esi, 0                              ; esi = 0
  mov rdx, ESTADISTICAS_SIZE              ; rdx = sizeof(estadisticas_t)
  call memset                             ; memset(res, 0, sizeof(estadisticas_t))

  cmp dword [rbp - 4], 0
  jbe .return
  .l0:
    cmp dword [rbp - 8], 0                ; if(usuario_id != 0) {
    jz .contabilizar
    mov rdi, [r12 + CASO_USUARIO_OFFSET]  ;   rdi = arreglo_casos[i].usuario;
    mov edi, [rdi + USUARIO_ID_OFFSET]    ;   edi = rdi->id;
    cmp edi, [rbp - 8]                    ;   if(edi != usuario_id)
    jne .continue                         ;     continue;
    .contabilizar:                        ;}
    mov rdi, [rbp - 16]                   ; rdi = res
    mov si, [r12 + CASO_ESTADO_OFFSET]    ; si = arreglo_casos[i].estado
    lea rdx, [r12 + CASO_CATEGORIA_OFFSET]; rdx = arreglo_casos[i].categoria
    call contabilizar                     ; contabilizar(res, estado, categoria)
  .continue:
    add r12, CASO_SIZE                    ; i++
    dec dword [rbp - 4]                   ;
    jnz .l0
  .return:
  mov rax, [rbp - 16]
  pop r12
  mov rsp, rbp
  pop rbp
  ret
