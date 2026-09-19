extern malloc
extern free
extern memcpy
section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio
NULL EQU 0
PTR_SIZE EQU 8
MAPA_SIZE EQU 255 * 255


section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - optimizar
global EJERCICIO_2A_HECHO
EJERCICIO_2A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_2B_HECHO
EJERCICIO_2B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

global optimizar
optimizar:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = mapa_t           mapa
	; r/m64 = attackunit_t*    compartida
	; r/m64 = uint32_t*        fun_hash(attackunit_t*)
  ; prologo, armamos el stack frame
  push rbp
  mov rbp, rsp
  sub rsp, 16

  push r12
  push r13

  mov r12, rdi                              ; mapa
  mov r13, rsi                              ; compartida
  mov [rbp - 8], rdx                        ; fun_hash
  mov dword [rbp - 12], MAPA_SIZE           ; i
  mov rdi, rsi                              ; rdi = compartida
  call [rbp - 8]                            ; fun_hash(rdi)
  mov [rbp - 16], eax                       ; eax = fun_hash(compartida)
  .for:                                     ; for(int i = 0; i < 255 * 255; i--)
    cmp qword [r12], NULL                   ; if(mapa[i] == NULL)
    je .continue                            ;   continue;
    mov rdi, [r12]
    call [rbp - 8]                          ; eax = fun_hash(mapa[i])
    cmp eax, [rbp - 16]                     ; if(fun_hash(mapa[i]) != fun_hash(compartida))
    jne .continue                           ;   continue;
    mov rdi, [r12]                          ; cUnit = mapa[i]
    mov [r12], r13                          ; mapa[i] = compartida
    inc byte [r13 + ATTACKUNIT_REFERENCES]  ; compartida->references++
    dec byte [rdi + ATTACKUNIT_REFERENCES]  ; cUnit->references--
    jnz .continue                           ; if(cUnit->references == 0)
    call free                               ;   free(cUnit)
    .continue:
    ; incremento puntero y decremento contador
    add r12, PTR_SIZE
    dec dword [rbp - 12]
    jnz .for

  pop r13
  pop r12

  ; epilogo
  mov rsp, rbp
  pop rbp
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; r/m64 = mapa_t           mapa
	; r/m64 = uint16_t*        fun_combustible(char*)
  push rbp
  mov rbp, rsp
  sub rsp, 32
  mov [rbp - 8], rdi                              ; mapa
  mov [rbp - 16], rsi                             ; fun
  mov qword [rbp - 24], 0                         ; i
  mov dword [rbp - 32], 0                         ; total
  .l0:                                            ; for(int i = 0; i < 255 * 255; i++)
    mov rdi, [rbp - 8]                            ; mapa
    ;mov rsi, [rbp - 16]                          ; fun
    mov rdx, [rbp - 24]                           ; i
    mov rdi, [rdi + 8 * rdx]                      ; mapa[i]
    test rdi, rdi                                 ; if(mapa[i] == NULL) continue
    jz .continue                                  ;   continue
    ;mov rdi, [rdi]                               ; rdi = cUnit->clase
    movzx esi, word [rdi + ATTACKUNIT_COMBUSTIBLE]; esi = cUnit->combustible
    add [rbp - 32], esi                           ; total += cUnit->combustible
    mov rax, [rdi + ATTACKUNIT_CLASE]             ; rax = cUnit->clase
    call [rbp - 16]                               ; fun_combustible(cUnit->clase)
    movzx eax, ax                                 ;
    sub [rbp - 32], eax                           ; total -= fun_combustible(rdi->clase)
  .continue:
    inc qword [rbp - 24]
    cmp qword [rbp - 24], 255 * 255
    jb .l0

  mov eax, [rbp - 32]
  mov rsp, rbp
  pop rbp
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
  push rbp
  mov rbp, rsp
  sub rsp, 48

  movzx rsi, sil
  mov rax, rsi                              ; rax = x
  sal rax, 8                                ; rax = x * 256
  sub rax, rsi                              ; rax = rax - x = x * 255
  movzx rdx, dl
  add rax, rdx                              ; rax = x * 255 + y
  mov [rbp - 8], rdi                        ; mapa
  mov [rbp - 16], rax                       ; x * 255 + y
  mov [rbp - 24], rcx                       ; fun_modificar
  ;mov qword [rbp - 32], 0                  ; attackunit_t *cUnit
  ;mov qword [rbp - 40], 0                  ; attackunit_t *nUnit

  mov rdi, [rdi + 8 * rax]                  ; rdi = cUnit = mapa[x][y]
  mov [rbp - 32], rdi
  test rdi, rdi                             ; if(!cUnit)
  jz .return                                ;   return;
  mov sil, [rdi + ATTACKUNIT_REFERENCES]    ;
  cmp sil, 1                                ; if(cUnit->references == 1)
  je .modificar                             ;   fun_modificar(cUnit);
                                            ; else {...
  mov rdi, ATTACKUNIT_SIZE                  ; rdi = sizeof(attackunit_t)
  call malloc                               ; malloc(sizeof(attackunit_t))
  mov [rbp - 40], rax                       ; nUnit = malloc(sizeof(attackunit_t))
  mov rdi, rax                              ; rdi = nUnit
  mov rsi, [rbp - 32]                       ; rsi = cUnit
  mov rdx, ATTACKUNIT_SIZE                  ; rdx = sizeof(attackunit_t)
  call memcpy                               ; memcpy(rdi, rsi, sizeof(attackunit_t))
  mov rdi, [rbp - 32]                       ; rdi = cUnit
  mov byte [rax + ATTACKUNIT_REFERENCES], 1 ; nUnit->references = 1
  sub byte [rdi + ATTACKUNIT_REFERENCES], 1 ; cUnit->references--
  mov rsi, [rbp - 8]                        ; rsi = mapa
  mov rdx, [rbp - 16]                       ; rdx = x * 255 + y
  mov [rsi + 8 * rdx], rax                  ; mapa[x][y] = nUnit
  mov rdi, rax                              ; rdi = nUnit
  .modificar:
  call [rbp - 24]                           ; fun_modificar(rdi)

  .return:
  mov rsp, rbp
  pop rbp
	ret
