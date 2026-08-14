#include <stdio.h>

int main() {
	int a = 5, b = 3, c = 2, d = 1;
	printf("a: %d, b: %d, c: %d, d: %d\n"
	"a + b * c / d = %d\n"
	"a %% b = %d\n"
	"a == b = %d, a != b = %d\n"
	"a & b = %x, a | b = %x\n"
	"~a = %x\n"
	"a && b = %d, a || b = %d\n"
	"a << 1 = %x\n"
	"a >> 1 = %x\n",
	a, b, c, d,
	a + b * c / d,
	a % b,
	a == b, a != b,
	a & b, a | b,
	~a,
	a && b, a || b,
	a << 1,
	a >> 1);
	printf("a += b = %d\n", a += b);
	printf("a -= b = %d\n", a -= b);
	printf("a *= b = %d\n", a *= b);
	printf("a %%= b = %d\n", a %= b);
}