#include <stdio.h>

int main() {
	int rot, ans[4], arr[] = {1,2,3,4};
	scanf("%d", &rot);
	for(int i = 0; i < 4; i++)
		ans[(i + rot) % 4] = arr[i];
	printf("{");
	for(int i = 0; i < 3; i++)
		printf("%d, ", ans[i]);
	printf("%d}\n", ans[3]);
}