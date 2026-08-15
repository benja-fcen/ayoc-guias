#include <stdio.h>
#include <stdint.h>

uint32_t fact(int n);

int main() {
	int n;
	scanf("%d", &n);
	printf("%u\n", fact(n));
}

uint32_t fact(int n) {
	if(n == 0) return 1;
	return n * fact(n - 1);
}