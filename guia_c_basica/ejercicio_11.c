#include <stdio.h>

int main() {
	int arr[] = {1,2,3,4};
	int ans[4];
	for(int i = 0; i < 4; i++)
		ans[(i + 1) % 4] = arr[i];
	printf("{");
	for(int i = 0; i < 3; i++)
		printf("%d, ", ans[i]);
	printf("%d}\n", ans[3]);
}