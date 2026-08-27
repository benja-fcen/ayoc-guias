extern malloc

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
;   - es_indice_ordenado
global EJERCICIO_1A_HECHO
EJERCICIO_1A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - indice_a_inventario
global EJERCICIO_1B_HECHO
EJERCICIO_1B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ITEM_NOMBRE EQU 0
ITEM_FUERZA EQU 20
ITEM_DURABILIDAD EQU 24
ITEM_SIZE EQU 28

;; La funcion debe verificar si una vista del inventario está correctamente 
;; ordenada de acuerdo a un criterio (comparador)

;; bool es_indice_ordenado(item_t** inventario, uint16_t* indice, uint16_t tamanio, comparador_t comparador);

;; Dónde:
;; - `inventario`: Un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice`: El arreglo de índices en el inventario que representa la vista.
;; - `tamanio`: El tamaño del inventario (y de la vista).
;; - `comparador`: La función de comparación que a utilizar para verificar el
;;   orden.
;; 
;; Tenga en consideración:
;; - `tamanio` es un valor de 16 bits. La parte alta del registro en dónde viene
;;   como parámetro podría tener basura.
;; - `comparador` es una dirección de memoria a la que se debe saltar (vía `jmp` o
;;   `call`) para comenzar la ejecución de la subrutina en cuestión.
;; - Los tamaños de los arrays `inventario` e `indice` son ambos `tamanio`.
;; - `false` es el valor `0` y `true` es todo valor distinto de `0`.
;; - Importa que los ítems estén ordenados según el comparador. No hay necesidad
;;   de verificar que el orden sea estable.

global es_indice_ordenado
es_indice_ordenado:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = item_t**     inventario
	; r/m64 = uint16_t*    indice
	; r/m16 = uint16_t     tamanio
	; r/m64 = comparador_t comparador
	push rbp
	mov rbp, rsp
	sub rsp, 64
	dec dx
	mov byte [rbp - 8], 1 ; res
	mov word [rbp - 16], 0; iterador
	mov qword [rbp - 24], rdi 	; inventario
	mov qword [rbp - 32], rsi 	; indice
	mov word [rbp - 48], dx		; tamanio
	mov qword [rbp - 64], rcx 	; comparador
	jmp .check
	.f0:
		mov rax, [rbp - 24] ; inventario
		mov rsi, [rbp - 32] ; indice
		movzx rdx, word [rbp - 16]  ; i
		movzx rcx, word [rsi + 2 * rdx] ; indice[i]
		mov rdi, [rax + 8 * rcx]; inventario[indice[i]]
		movzx rcx, word [rsi + 2 * rdx + 2] ; indice[i + 1]
		mov rsi, [rax + 8 * rcx] ; inventario[indice[i + 1]]
		mov rdx, [rbp - 64]
		call rdx
		and [rbp - 8], al
		inc word [rbp - 16]	
	.check:
		mov dx, [rbp - 48]
		cmp [rbp - 16], dx
		jne .f0
	mov al, [rbp - 8]
	mov rsp, rbp
	pop rbp
	ret

;; Dado un inventario y una vista, crear un nuevo inventario que mantenga el
;; orden descrito por la misma.

;; La memoria a solicitar para el nuevo inventario debe poder ser liberada
;; utilizando `free(ptr)`.

;; item_t** indice_a_inventario(item_t** inventario, uint16_t* indice, uint16_t tamanio);

;; Donde:
;; - `inventario` un array de punteros a ítems que representa el inventario a
;;   procesar.
;; - `indice` es el arreglo de índices en el inventario que representa la vista
;;   que vamos a usar para reorganizar el inventario.
;; - `tamanio` es el tamaño del inventario.
;; 
;; Tenga en consideración:
;; - Tanto los elementos de `inventario` como los del resultado son punteros a
;;   `ítems`. Se pide *copiar* estos punteros, **no se deben crear ni clonar
;;   ítems**

global indice_a_inventario
indice_a_inventario:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = item_t**  inventario
	; r/m64 = uint16_t* indice
	; r/m16 = uint16_t  tamanio
  push rbp
  mov rbp, rsp
  sub rsp, 64
  mov [rbp - 8], rdi
  mov [rbp - 16], rsi
  movzx rdx, dx
  mov [rbp - 32], rdx
  
  movzx rdi, dx
  call malloc                       ; rax = resultado
  mov rcx, 0                        ; i
  mov rdi, [rbp - 8]                ; inventario
  mov rsi, [rbp - 16]               ; indice
  jmp .c0
  .f0:
    movzx rdx, WORD [rsi + 2 * rcx] ; indice[i]
    mov rdx, [rdi + 8 * rdx]        ; inventario[indice[i]]
    mov [rax + 8 * rcx], rdx        ; resultado[i] = inventario[indice[i]]
    inc rcx
  .c0:
    cmp rcx, [rbp - 32]
    jb .f0
  mov rsp, rbp
  pop rbp
	ret
