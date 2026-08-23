extern strcpy
extern malloc
extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

ITEM_OFFSET_NOMBRE EQU 0
ITEM_OFFSET_ID EQU 12
ITEM_OFFSET_CANTIDAD EQU 16

POINTER_SIZE EQU 8
UINT32_SIZE EQU 4

NULL EQU 0
; Marcar el ejercicio como hecho (`true`) o pendiente (`false`).

global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_4_HECHO
EJERCICIO_4_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global ejercicio1
ejercicio1:
	add rdi, rcx
	add rdi, rdx
    add rdi, rsi
    add rdi, r8
	mov rax, rdi
	ret

global ejercicio2
;void ejercicio2(item_t* un_item, uint32_t id, uint32_t cantidad, char nombre[])
ejercicio2:
    push rbp
    mov rbp, rsp
	mov [rdi+ITEM_OFFSET_ID], esi
	mov [rdi+ITEM_OFFSET_CANTIDAD], edx
    mov rsi, rcx
	call strcpy 
    mov rsp, rbp
    pop rbp
	ret


global ejercicio3
;uint32_t ejercicio3(uint32_t* array, uint32_t size, uint32_t (*fun_ej_3)(uint32_t a, uint32_t b))
; rdi = arr
; esi = size
; rdx = fun
ejercicio3:
    push rbp
    mov rbp, rsp
    sub rsp, 48
	cmp rsi, 0
	je .vacio
	cmp rsi, 1
    je .unico
    
    dec esi             ; n = n - 1
    mov [rbp - 8], rdi  ; arr
    mov [rbp - 16], esi ; size = n
    mov [rbp - 24], rdx ; fun
    call ejercicio3
    mov [rbp - 32], eax ; eax = ej3(arr, n - 1, fun)
    mov edi, eax                ; edi = ej3(arr, n - 1, fun)
    mov rdx, [rbp - 8]          ; rdx = arr
    mov ecx, [rbp - 16]         ; ecx = n - 1
    mov esi, [rdx + 4 * rcx]    ; rsi = rdx[ecx]
    call [rbp - 24]             ; eax = fun(rdi, arr[n - 1])
    add eax, [rbp - 32]
    jmp .end

    .unico:
	mov rcx, rdi      ; array
	;mov r8, 0 ; sumatoria ; r8
	;mov r9, 0 ; i         ; r9
    ;mov [rbp - 32], rdx     ; fun
    ;mov [rbp - 40], rsi     ; n

	.loop:
    ;mov rcx, [rbp - 8]
	mov edi, 0      ; rdi = r8 = a
	mov esi, [rcx]   ; rsi = rcx[r9] = b

	call rdx

	;add [rbp - 16], rax
	;mov rax, [rbp - 16]

    ;mov rsi, [rbp - 40]
	;inc QWORD [rbp - 24]
	;cmp [rbp - 24], rsi
	jmp .end

	;jmp .loop

	.vacio:
	mov rax, 64

	.end:
    mov rsp, rbp
    pop rbp
	ret

global ejercicio4
; uint32_t* ejercicio4(uint32_t** array, uint32_t size, uint32_t constante);
ejercicio4:
    push rbp
    mov rbp, rsp
    sub rsp, 8
    push r12
    push r13
    push r14
    push r15
    push rbx

	mov r12, rdi    ; array
	mov r13, rsi    ; size
	mov r14, rdx    ; constante

	xor rdi, rdi
    lea edi, [esi * UINT32_SIZE]

	call malloc
	mov r15, rax    ; r15 = malloc(esi * sizeof(uint32_t))
	
	xor rbx, rbx    ; rbx = 0
	.loop:
	
	cmp rbx, r13                    ; for(rbx = 0; rbx < 13; rbx++)
	je .end

	mov r8, [r12+rbx*POINTER_SIZE]  ;   uint32_t *r8 = array[rbx]
	mov r9d, [r8]                   ;   r9d = *r8
	mov rax, r14                    ;   rax = C
	mul r9d                         ;   rax = rax * r9d
	mov [r15+rbx*UINT32_SIZE], eax  ;   r15[rbx] = eax
	
	mov rdi, r8                     ;   rsi = r8 
	call free                       ;   free(array[rbx])
    mov QWORD [r12 + rbx * POINTER_SIZE], NULL

	inc rbx                         ; 
	jmp .loop

	.end:
	mov rax, r15
    pop rbx
    pop r15
    pop r14
    pop r13
    pop r12
    mov rsp, rbp
    pop rbp
	ret
