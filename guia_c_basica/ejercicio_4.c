#include <stdio.h>
#include <stdint.h>

int main() {
	printf(
	"Tipo\t| Tamaño en bytes\n"
	"int8_t  \t%lu\n"
	"int16_t \t%lu\n"
	"int32_t \t%lu\n"
	"int64_t \t%lu\n", sizeof(int8_t), sizeof(int16_t), sizeof(int32_t), sizeof(int64_t));
}