#include <stdint.h>
#include "type.h"

static int count = 0;

fat32_t *new_fat32() {
    fat32_t *r = malloc(sizeof(fat32_t));
    *r = count++;
    return r;
}

ext4_t *new_ext4() {
    ext4_t *r = malloc(sizeof(ext4_t));
    *r = count++;
    return r; 
}

ntfs_t* new_ntfs() {
    ntfs_t *r = malloc(sizeof(ntfs_t));
    *r = count++;
    return r;
}

fat32_t* copy_fat32(fat32_t* file) {
    fat32_t *r = malloc(sizeof(fat32_t));
    *r = *file;
    return r;
}

ext4_t* copy_ext4(ext4_t* file) {
    ext4_t *r = malloc(sizeof(ext4_t));
    *r = *file;
    return r; 
}

ntfs_t* copy_ntfs(ntfs_t* file) {
    ntfs_t *r = malloc(sizeof(ntfs_t));
    *r = *file;
    return r;
}

void rm_fat32(fat32_t* file) {
    free(file);
}

void rm_ext4(ext4_t* file) {
    free(file);
}

void rm_ntfs(ntfs_t* file) {
    free(file);
}