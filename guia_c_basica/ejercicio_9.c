#include <stdio.h>
#include <stdint.h>
#define SIZE_IN_BITS sizeof(int32_t) * 8


int main() {
	int32_t a, b;
	scanf("%d%d", &a, &b);
	a = (a >> (SIZE_IN_BITS - 3)) & 0x07;
	b &= 0x07;
	printf(a == b ? "iguales\n" : "diferentes\n");
}