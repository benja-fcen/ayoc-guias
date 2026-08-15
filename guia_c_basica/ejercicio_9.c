#include <stdio.h>
#include <stdint.h>

int main() {
	uint32_t a, b;
	scanf("%u%u", &a, &b);
	a = a >> 29;
	b &= 0x7;
	printf(a == b ? "iguales\n" : "diferentes\n");
}