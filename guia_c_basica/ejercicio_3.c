#include <stdio.h>

int main() {
    char c = 'a';
    unsigned char uc = '2';
    short h = 32767;
    unsigned short hu = 65535;
    int d = 45;
    unsigned u = 24;
    long ld = 99;
    unsigned long lu = 879;
    printf("char: %c\n"
        "unsigned char: %c\n"
        "short: %hd\n"
        "unsgined short: %hu\n"
        "int: %d\n"
        "unsgined: %u\n"
        "long: %ld\n"
        "unsgined long: %lu\n", c, uc, h, hu, d, u, ld, lu);
}