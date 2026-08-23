extern malloc
extern free
extern fprintf

section .data
equal:
dd 0
below:
dd -1

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; int32_t min(int a, int b)
min:
    mov eax, esi
    cmp edi, esi
    cmovb eax, edi
    ret


; ** String **
; int32_t strCmp(char* a, char* b, int len)
strNCmp:
    push rbp
    mov rbp, rsp        ; rdi = a
    sub rsp, 16         ; rsi = b
    lea ecx, [edx + 1]  ; ecx = len + 1
    xor eax, eax
    cld                 ; limpio flag de dirección
    repe cmpsb          ; temp = 0;
    mov eax, 0          ; for(int i = 0; i < ecx && temp == 0; i++)
    jz .return          ;   temp = rsi[i] - rdi[i]
    mov eax, -1         ; if(temp == 0) return 0;
    js .return          ; if(temp < 0) return 1;
    mov eax, 1          ; if(temp > 0) return -1;
    .return:        
    mov rsp, rbp        ; restauro stack
    pop rbp
    ret


; int32_t strCmp(char* a, char* b)
strCmp:
	push rbp
    mov rbp, rsp 
    sub rsp, 24
    mov [rbp - 8], rdi
    mov [rbp - 16], rsi
    call strLen         ; eax = strLen(a)
    mov [rbp - 24], eax ; [rbp - 24] = strlen(a)
    mov rdi, [rbp - 16] 
    call strLen         ; eax = strlen(b)
    mov edx, [rbp - 24] ; edx = strlen(a)
    cmp eax, edx        
    cmovb edx, eax      ; edx = strlen(b) < strlen(a) ? strlen(b) : strlen(a)
    mov rdi, [rbp - 8]  ; rdi = a
    mov rsi, [rbp - 16] ; rsi = b
    call strNCmp        ; eax = strNCmp(a, b, edx)
    mov rsp, rbp        ; restauro stack
    pop rbp
    ret



; char* strClone(char* a)
strClone:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov [rbp - 8], rdi  ; [rbp - 8] = a
    call strLen
    inc eax
    mov [rbp - 16], eax ; [rbp - 16] = strLen(a)
    mov edi, eax
    call malloc         ; char *rax = malloc(sizeof(strLen(a)))
    mov rdi, rax        ; char *rdi = ret
    mov rsi, [rbp - 8]  ; char *rsi = a
    mov ecx, [rbp - 16] ; int ecx = strLen(a)
    cld                 ; Limpiamos flag de direccion
    repe movsb          ; for(int i = 0; i < ecx; i++)
                        ;   rdi[i] = rsi[i]
    mov rsp, rbp        ; restauro stack
    pop rbp
	ret

; void strDelete(char* a)
strDelete:
    push rbp
    mov rbp, rsp
    call free
    mov rsp, rbp
    pop rbp
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
    push rdi
    mov eax, -1
    xor rcx, rcx
    .l0:
        inc eax
        mov dl, [rdi + rcx]
        inc rcx
        test dl, dl
        jnz .l0
    pop rdi
	ret


