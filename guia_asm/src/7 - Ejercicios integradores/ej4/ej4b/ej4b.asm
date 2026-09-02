extern strcmp
extern strncmp
global invocar_habilidad

; Completar las definiciones o borrarlas (en este ejercicio NO serán revisadas por el ABI enforcer)
DIRENTRY_NAME_OFFSET EQU 0
DIRENTRY_PTR_OFFSET EQU 16
DIRENTRY_SIZE EQU 24

FANTASTRUCO_DIR_OFFSET EQU 0
FANTASTRUCO_ENTRIES_OFFSET EQU 8
FANTASTRUCO_ARCHETYPE_OFFSET EQU 16
FANTASTRUCO_FACEUP_OFFSET EQU 24
FANTASTRUCO_SIZE EQU 32

PTR_SIZE equ 8

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text

; void invocar_habilidad(void* carta, char* habilidad);
invocar_habilidad:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; r/m64 = void*    card ; Vale asumir que card siempre es al menos un card_t*
	; r/m64 = char*    habilidad
  push rbp
  mov rbp, rsp
  sub rsp, 8
  mov byte [rbp - 1], 0   ; contieneHabilidad
  mov word [rbp - 4], 0   ; i = carta->__dir_entries
  push r12                                      ; card
  push r13                                      ; habilidad
  push r14                                      ; card->__dir
  mov r12, rdi                                  ; card
  mov r13, rsi                                  ; habilidad

  test rdi, rdi                                 ; if(!card)
  jz .return                                    ;   return
  mov r14, [rdi + FANTASTRUCO_DIR_OFFSET]       ; card->__dir
  mov di, [r12 + FANTASTRUCO_ENTRIES_OFFSET]
  test di, di                                   ; if(card->__dir_entries == 0)
  jz .invocar_arquetipo                         ;   invocar_habilidades(carta->archetype, habilidad)
  mov [rbp - 4], di                             ; carta->__dir_entries

  .do:
    mov rdi, [r14]                              ; rdi = carta->__dir[i]
    ;lea rdi, [rdi + DIRENTRY_NAME_OFFSET]      ; rdi = carta->__dir[i]->ability_name
    mov rsi, r13                                ; rsi = habilidad
    ;call strcmp
    mov rdx, 10                                 ; rdx = 10
    call strncmp                                ; eax = strncmp(cart->__dir[i]->ability_name, habilidad, 10)
  .while:
    test eax, eax                               ;
    setz [rbp - 1]                              ; contieneHabilidad = !eax
    jz .break                                   ; if(contieneHabilidad) break;
    add r14, PTR_SIZE                           ; ++i
    dec word [rbp - 4]
    jnz .do
  
  .break:
  test byte [rbp - 1], 1                        ; if(contieneHabilidad) {
  jz .invocar_arquetipo                         ;
  mov rdi, r12                                  ;   rdi = card
  mov rsi, [r14]; rsi = carta->__dir[i]         ;   rsi = carta->__dir[i]
  mov rsi, [rsi + DIRENTRY_PTR_OFFSET]          ;   rsi = carta->__dir[i]->ability_ptr
  call rsi                                      ;   carta->__dir[i]->ability_ptr(card)
  jmp .return                                   ; }
  .invocar_arquetipo:                           ; else {
  mov rdi, [r12 + FANTASTRUCO_ARCHETYPE_OFFSET] ;   rdi = card->archetype
  mov rsi, r13                                  ;   rsi = habilidad
  call invocar_habilidad                        ;   invocar_habilidad(card->archetype, habilidad)
  .return:                                      ; }
  pop r14
  pop r13
  pop r12
  mov rsp, rbp
  pop rbp
	ret ;No te olvides el ret!
