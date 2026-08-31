extern strncmp

;########### SECCION DE DATOS
section .data
clt: db 'CLT', 0
rbo: db 'RBO', 0
len: dd 4


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

global resolver_automaticamente

; rdi = caso
; rsi = categoria
resolver_caso_por_categoria:
  push rbp
  mov rbp, rsp
  sub rsp, 16
  mov [rbp - 8], rdi                    ; caso
  mov [rbp - 16], rsi                   ; categoria

  mov rdi, rsi                          ; categoria
  mov rsi, clt                          ; "CLT"
  mov edx, [len]                        ; 4
  call strncmp                          ; eax = strncmp(categoria, "CLT", 4)
  test eax, eax                         ; if(eax != 0)
  jz .solve                             ; {...
  mov rdi, [rbp - 16]                   ; categoria
  mov rsi, rbo                          ; "RBO"
  mov edx, [len]                        ; 4
  call strncmp                          ; eax = strncmp(categoria, "RBO", 4)
  test eax, eax                         ; if(eax != 0)
  mov al, 0                             ;
  jnz .return                            ; return false
  .solve:
  mov rdi, [rbp - 8]                     ; caso
  mov word [rdi + CASO_ESTADO_OFFSET], 2 ; caso->estado = 2

  .return:
  mov rsp, rbp
  pop rbp
  ret


; rdi = caso
; rsi = resultado_funcion
resolver_caso_por_funcion:
  push rbp
  mov rbp, rsp
  
  test rsi, rsi                         ; if(resultado_funcion)
  jz .resolver_por_categoria            ;
  mov word [rdi + CASO_ESTADO_OFFSET],1 ;   caso->estado = 1
  mov al, 1                             ;   return true
  jmp .return                           ;
  .resolver_por_categoria:              ; else
  mov rsi, rdi                          ; lea rsi, [rdi + CASO_CATEGORIA_OFFSET]
  call resolver_caso_por_categoria      ; return resolver_caso_por_categoria(caso, caso->categoria)

  .return:
  mov rsp, rbp
  pop rbp
  ret

; rdi = caso
; rsi = funcion
; edx = nivel
resolver_caso_por_nivel:
  push rbp
  mov rbp, rsp
  
  mov al, 0
  cmp edx, 0                      ; if(nivel == 0)
  je .return                      ;   return false
  cmp edx, 3                      ; if(nivel >= 3)
  jae .return                     ;   return false
  sub rsp, 16
  mov [rbp - 8], rdi
  call rsi                        ; ax = funcion(caso)
  mov rdi, [rbp - 8]              ; rdi = caso
  movzx rsi, ax                   ; rsi = funcion(caso)
  call resolver_caso_por_funcion  ; resolver_caso_por_funcion(caso, funcion(caso))

  .return:
  mov rsp, rbp
  pop rbp
  ret


; rdi = caso
; rsi = funcion
resolver_caso:
  push rbp
  mov rbp, rsp

  mov rdx, [rdi + CASO_USUARIO_OFFSET]  ; rdx = caso->usuario
  mov edx, [rdx + USUARIO_NIVEL_OFFSET] ; edx = usuario->nivel
  call resolver_caso_por_nivel          ; resolver_caso_por_nivel(caso, funcion, nivel)

  mov rsp, rbp
  pop rbp
  ret


;void resolver_automaticamente(funcionCierraCasos* funcion, caso_t* arreglo_casos, caso_t* casos_a_revisar, int largo)
; rdi = funcion
; rsi = arreglo_casos
; rdx = casos_a_revisar
; ecx = largo
resolver_automaticamente:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 4], ecx  ; largo
    mov [rbp - 16], rdi ; funcion
    push r12
    push r13
    mov r12, rsi ; &arreglo_casos
    mov r13, rdx ; casos_a_revisar

    test ecx, ecx
    jz .return
    .l0:
      mov rdi, r12        ; rdi = &arreglo_casos[i]
      mov rsi, [rbp - 16] ; rsi = funcion
      call resolver_caso
      test al, al
      jnz .continue
      mov [r13], r12
      add r13, CASO_SIZE
    .continue:
      add r12, CASO_SIZE
      dec dword [rbp - 4]
      jnz .l0
    .return:
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
    ret
