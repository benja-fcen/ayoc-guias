; Definiciones comunes
TRUE  EQU 1
FALSE EQU 0

; Identificador del jugador rojo
JUGADOR_ROJO EQU 1
; Identificador del jugador azul
JUGADOR_AZUL EQU 2

; Ancho y alto del tablero de juego
tablero.ANCHO EQU 10
tablero.ALTO  EQU 5

; Marca un OFFSET o SIZE como no completado
; Esto no lo chequea el ABI enforcer, sirve para saber a simple vista qué cosas
; quedaron sin completar :)
NO_COMPLETADO EQU -1

extern strcmp

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
PTR_SIZE EQU 8
; Completar las definiciones (serán revisadas por ABI enforcer):
carta.en_juego EQU 0
carta.nombre   EQU 1
carta.vida     EQU 14
carta.jugador  EQU 16
carta.SIZE     EQU 18

tablero.mano_jugador_rojo EQU 0
tablero.mano_jugador_azul EQU 8
tablero.campo             EQU 16
tablero.SIZE              EQU 16 + PTR_SIZE * tablero.ANCHO * tablero.ALTO

accion.invocar   EQU 0
accion.destino   EQU 8
accion.siguiente EQU 16
accion.SIZE      EQU 24

; Variables globales de sólo lectura
section .rodata

; Marca el ejercicio 1 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - hay_accion_que_toque
global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE

; Marca el ejercicio 2 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - invocar_acciones
global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE

; Marca el ejercicio 3 como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contar_cartas
global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE

section .text

; Dada una secuencia de acciones determinar si hay alguna cuya carta tenga un
; nombre idéntico (mismos contenidos, no mismo puntero) al pasado por
; parámetro.
;
; El resultado es un valor booleano, la representación de los booleanos de C es
; la siguiente:
;   - El valor `0` es `false`
;   - Cualquier otro valor es `true`
;
; ```c
; bool hay_accion_que_toque(accion_t* accion, char* nombre);
; ```
global hay_accion_que_toque
hay_accion_que_toque:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = accion_t*  accion
	; r/m64 = char*      nombre
	push rbp
  mov rbp, rsp
  sub rsp, 8
  mov [rbp - 8], rsi ; nombre
  push r12
  mov r12, rdi  ; accion
  mov eax, 1
  jmp .c0
  .f0:
    mov rdi, [r12 + accion.destino] ; rdi = accion->destino
    lea rdi, [rdi + carta.nombre]   ; rdi = accion->destino->nombre
    mov rsi, [rbp - 8]              ; rsi = nombre
    call strcmp
    mov r12, [r12 + accion.siguiente]
  .c0:
    test eax, eax
    setz al
    jz .return
    test r12, r12
    jnz .f0
  
  .return:
  pop r12
  mov rsp, rbp
  pop rbp
	ret

; Invoca las acciones que fueron encoladas en la secuencia proporcionada en el
; primer parámetro.
;
; A la hora de procesar una acción esta sólo se invoca si la carta destino
; sigue en juego.
;
; Luego de invocar una acción, si la carta destino tiene cero puntos de vida,
; se debe marcar ésta como fuera de juego.
;
; Las funciones que implementan acciones de juego tienen la siguiente firma:
; ```cclr x86
; void mi_accion(tablero_t* tablero, carta_t* carta);
; ```
; - El tablero a utilizar es el pasado como parámetro
; - La carta a utilizar es la carta destino de la acción (`accion->destino`)
;
; Las acciones se deben invocar en el orden natural de la secuencia (primero la
; primera acción, segundo la segunda acción, etc). Las acciones asumen este
; orden de ejecución.
;
; ```c
; void invocar_acciones(accion_t* accion, tablero_t* tablero);
; ```
global invocar_acciones
invocar_acciones:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = accion_t*  accion
	; r/m64 = tablero_t* tablero
  push rbp
  mov rbp, rsp
  sub rsp, 16
  push r12
  push r13
  
  mov [rbp - 8], rsi  ; tablero
  mov r12, rdi        ; accion
  jmp .c0
  .f0:
    mov r13, [r12 + accion.destino]     ; carta
    cmp byte [r13 + carta.en_juego], 0  ; if(carta->en_juego) {
    je .continue                        ;
    mov rdi, [rbp - 8]                  ;   rdi = tablero
    mov rsi, r13                        ;   rsi = carta
    mov rdx, [r12 + accion.invocar]     ;   rdx = accion_actual->invocar
    call rdx                            ;   accion_actual(tablero, carte)}
    cmp byte [r13 + carta.en_juego], 0  ; if(carta->en_juego) {
    je .continue
    cmp word [r13 + carta.vida], 0      ; carta->en_juego = carta->vida > 0
    seta [r13 + carta.en_juego]         ; }
  .continue:                            ;
    mov r12, [r12 + accion.siguiente]   ; accion_actual = accion_actual->siguiente
  .c0:                                  ;
    test r12, r12                       ;
    jnz .f0

  pop r13
  pop r12
  mov rsp, rbp
  pop rbp
	ret

; Cuenta la cantidad de cartas rojas y azules en el tablero.
;
; Dado un tablero revisa el campo de juego y cuenta la cantidad de cartas
; correspondientes al jugador rojo y al jugador azul. Este conteo incluye tanto
; a las cartas en juego cómo a las fuera de juego (siempre que estén visibles
; en el campo).
;
; Se debe considerar el caso de que el campo contenga cartas que no pertenecen
; a ninguno de los dos jugadores.
;
; Las posiciones libres del campo tienen punteros nulos en lugar de apuntar a
; una carta.
;
; El resultado debe ser escrito en las posiciones de memoria proporcionadas
; como parámetro.
;
; ```c
; void contar_cartas(tablero_t* tablero, uint32_t* cant_rojas, uint32_t* cant_azules);
; ```
global contar_cartas
contar_cartas:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = tablero_t* tablero
	; r/m64 = uint32_t*  cant_rojas
	; r/m64 = uint32_t*  cant_azules
  push rbp
  mov rbp, rsp
  sub rsp, 8
  push r12
  push r13
  push r14

  mov dword [rsi], 0
  mov dword [rdx], 0
  mov r12, rsi                    ; cant_rojas
  mov r13, rdx                    ; cant_azules
  lea r14, [rdi + tablero.campo]  ; tablero->campo
  mov ecx, tablero.ANCHO * tablero.ALTO
  mov esi, 0
  mov edx, 0

  .f0:
    mov rdi, [r14]                  ; rdi = campo[i][j]
    test rdi, rdi                   ; if(tablero->campo[i][j]) {
    jz .continue                    ;
    mov dil, [rdi + carta.jugador]    ; dil = tablero->campo[i][j]->jugador
      cmp dil, JUGADOR_ROJO
      sete sil                        ; sil = jugador == JUGADOR_ROJO
      cmp dil, JUGADOR_AZUL
      sete dl                         ; dl = jugador == JUGADOR_AZUL
      add [r12], esi                  ; *cant_rojas += jugador == JUGADOR_ROJO
      add [r13], edx                  ; *cant_azules += jugador == JUGADOR_AZUL
  .continue:
    add r14, 8
    loop .f0

  pop r14
  pop r13
  pop r12
  mov rsp, rbp
  pop rbp
	ret
