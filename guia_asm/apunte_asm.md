### Apunte ASM (64 bits)

##Registros en 64 bits


|Tipo de registro        | Registro                                         |
|------------------------|--------------------------------------------------|
|Registros de Byte       | AL, BL, CL, DL, DIL, SIL, BPL, SPL, R8B-R15B     |
|Registros de Word       | AX, BX, CX, DX, DI, SI, BP, SP, R8W, D15W        |
|Registros de Doubleword | EAX, EBX, ECX, EDX, EDI, ESI, ESP, R8D - R15D    |
|Registros de Quadword   | RAX, RBX, RCX, RDX, RDI, RSI, RBP, RSP, R8 - R15 |

>[!NOTE]
>Para acceder solo a la parte alta de los registros AX, BX, CX y DX, se pueden usar los registros AH, BH, CH y DH respectivamente.

En modo de 64 bits, el tamaño de los operandos determina el número de bits válidos en el registro de propósito general destino:
- Los operandos de 64 bit, generan un resultado de 64 bit en el registro destino.
- Los operandos de 32 bit, generan un resultado de 32 bit, extendido por ceros a un resultado de 64 bit en el registro destino.
- Los operandos de 8 y 16 bit generan un reultado de 8 o 16 bit. Los 56 o 48 bits (respectivamente) mas altos de registro destino no son modificados por la operación. Si el resultado de una operación de 8 o 16 bit está destinada a cálculos de direcciones de 64 bit, se debe extender el registro a 64 bit de forma explícita.

## System V ABI
#Tipos escalares

| Type      | C                   | sizeof | Alignment (bytes) | AMD64 Architecture |
|-----------|---------------------|:------:|:-----------------:|--------------------|
| Integral  | _Bool               | 1      | 1                 | boolean            |
|           | char                | 1      | 1                 | signed byte        |
|           | signed char         | 1      | 1                 | signed byte        |
|           | unsigned char       | 1      | 1                 | unsigned byte      |
|           | short               | 2      | 2                 | signed twobyte     |
|           | signed short        | 2      | 2                 | signed twobyte     |
|           | unsigned short      | 2      | 2                 | unsigned twobyte   |
|           | int                 | 4      | 4                 | signed fourbyte    |
|           | signed int          | 4      | 4                 | signed fourbyte    |
|           | enum                | 4      | 4                 | signed fourbyte    |
|           | unsigned int        | 4      | 4                 | unsigned fourbyte  |
|           | long                | 8      | 8                 | signed eightbyte   |
|           | signed long         | 8      | 8                 | signed eightbyte   |
|           | long long           | 8      | 8                 | signed eightbyte   |
|           | signed long long    | 8      | 8                 | signed eightbyte   |
|           | unsigned long       | 8      | 8                 | unsigned eightbyte |
|           | unsigned long long  | 8      | 8                 | unsigned eightbyte |
| Pointer   | any-type *          | 8      | 8                 | unsigned eightbyte |
|           | any-type (*) ()     | 8      | 8                 | unsigned eightbyte |
| Floating- | float               | 4      | 4                 | single (IEEE-754)  |
| Point     | double              | 8      | 8                 | double (IEEE-754)  |
|           | long double         | 16     | 16                | 80-bit extended (IEEE-754) |

# Pasaje de parámetros
Según el tipo de parámetro, los registros se asignan para el pasaje (en orden de izquierda a derecha), de la siguiente forma:

1. Si el tipo es entero o puntero, se usa el siguiente registro disponible en la secuencia: rdi, rsi, rdx, rcx, r8 y r9.

2. Si el tipo de dato es de punto flotante, se usa el siguiente registro xmm, los registros se toman en orden desde xmm0 hasta xmm7.

3. Una vez que se asignan los registros, los argumentos se pasan pusheados por el stack en orden invertido (de derecha a izquierda).

# Retorno de valores
1. Si el tipo es entero o puntero, se devuelve por rax.

2. Si el tipo es de punto punto flotante, se devuelve por xmm0.

# Registros
Los registros no volatiles son: RBX, RSP, RBP, R12-R15
