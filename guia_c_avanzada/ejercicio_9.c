#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

bool is_lower(const char *c) {
    return 'a' <= *c && *c <= 'z';
}

void str_to_upper(char *str, size_t len) {
    for(uint32_t i = 0; i < len; i++)
        if(is_lower(&str[i]))
            str[i] -= 'a' - 'A';
}

int main() {
    char str[15] = "Hello world!!";
    printf("String original: \"%s\"\n", str);
    str_to_upper(str, 15);
    printf("String en mayúsuclas: %s\n", str);
    return 0;
}