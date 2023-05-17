#include <string.h>
#include <memory.h>
#include <stdlib.h>

char *strcat_s(char **dest, const char *src) {
    char *new_dest = realloc(*dest, strlen(*dest) + strlen(*src) + 1);
    if(new_dest == NULL) return NULL;
    *dest = new_dest;
    strcat(*dest, src);
    return *dest;
}