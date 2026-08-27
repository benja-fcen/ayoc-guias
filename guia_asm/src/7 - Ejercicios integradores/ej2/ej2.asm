extern malloc
extern free 
section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

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
EJERCICIO_2B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

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
  push rbp
  mov rbp, rsp
  sub rsp, 48
  mov [rbp - 8], rdi          ; mapa
  mov [rbp - 16], rsi         ; compartida
  mov [rbp - 24], rdx         ; fun_hash
  mov QWORD [rbp - 32], 0           ; i
  mov BYTE [rbp - 40], 0           ; fun_hash(compartida)
  mov rdi, rsi
  call [rbp - 24]
  mov [rbp - 40], ax
  .l0:
    mov rcx, [rbp - 32]       ; i
    mov rdi, [rbp - 8]        ; mapa
    mov rdi, [rdi + 8 * rcx]  ; cUnit = mapa[i]
    test rdi, rdi
    jz .continue
    call [rbp - 24]           ;
    sub ax, [rbp - 40]        ;
    jnz .continue             ;
    mov rcx, [rbp - 32]       ; i
    mov r8, [rbp - 8]         ; mapa
    mov rsi, [r8 + 8 * rcx]   ; cUnit = mapa[i]
    mov rdx, [rbp - 16]       ; compartida

    mov rcx, ATTACKUNIT_REFERENCES   
    mov [r8 + 8 * rcx], rdx   ; mapa[i] = compartida
    inc BYTE [rdx + rcx]      ; compartida->references++
    dec BYTE [rsi + rcx]      ; cUnit->references--
    jnz .continue
    call free
    .continue:
    inc QWORD [rbp - 32]
  .c0:
    test QWORD [rbp - 32], 256 * 256
    jz .l0
  mov rsp, rbp
  pop rbp
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; r/m64 = mapa_t           mapa
	; r/m64 = uint16_t*        fun_combustible(char*)
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret
