extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

PTR_SIZE EQU 8
UINT16_SIZE EQU 2

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
  ; prologo
	push rbp
	mov rbp, rsp

  sub rsp, 8
  push r12
  push r13
	push r14                              ; pila alineada

	mov r12, rdi                          ; inventario
	mov r13, rsi                          ; indice
	mov [rbp - 8], dx                     ; tamanio
	mov r14, rcx                          ; comparador
  mov al, 1                             ; res = 1
	jmp .check                            ; saltamos directo al check, y decrementamos el contador, esto lo hacemos porque vamos a contar hasta 'tamanio - 1' (como en el código en C).
	.for:
		movzx rdi, word [r13]               ; rdi = indice[i]
    movzx rsi, word [r13 + UINT16_SIZE] ; rsi = indice[i + 1]
		mov rdi, [r12 + rdi * PTR_SIZE]     ; inventario[indice[i]]
		mov rsi, [r12 + rsi * PTR_SIZE]     ; inventario[indice[i + 1]]
		call r14
  ; Incremento puntero
    add r13, UINT16_SIZE
  ; Chequeo de condiciones
    test al, al
    jz .return
  .check:
    dec word [rbp - 8]                  ; [rbp - 8] = [rbp - 8] - 1
		jg .for                              ; jump if [rbp - 8] > 1 <=> [rbp - 8] - 1 > 0
    ;jnz -> Ojo con esto, se rompe si entran números negativos. Por ejemplo, podría entrar dx = 0, y luego el dec, nos deja con [rbp - 8] = -1.

  .return:
  ; restauro registro no-volatiles
  pop r14
  pop r13
  pop r12

  ; epilogo
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
  ; prologo
  push rbp
  mov rbp, rsp

  sub rsp, 8                        ; alineación de pila
  push rdi                          ; ->inventario
  push rsi                          ; ->indice
  movzx rdi, dx                     ; convierto dx a qword extendiendo con ceros
  push rdi                          ; ->tamanio

  shl rdi, 3                        ; rdi = rdi * PTR_SIZE
  call malloc                       ; rax = resultado
  pop rcx                           ; <- tamanio
  pop rsi                           ; <- indice
  pop rdi                           ; <- inventario
  mov r8, rax
  jrcxz .return
  .for:
    movzx rdx, word [rsi]           ; indice[i]
    mov rdx, [rdi + rdx * PTR_SIZE] ; inventario[indice[i]]
    mov [r8], rdx                   ; resultado[i] = inventario[indice[i]]
    ; Incrementamos punteros
    add rsi, UINT16_SIZE
    add r8, PTR_SIZE
    loop .for
  .return:
 
  ;epilogo
  mov rsp, rbp
  pop rbp
	ret
