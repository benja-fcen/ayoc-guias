#include <stdio.h>

int main() {
	float f = 0.1;
	double d = 0.1;
	printf(
	"%f\n"
	"%lf\n"
	"%d\n"
	"%d\n", f, d, (int) f, (int) d);
}