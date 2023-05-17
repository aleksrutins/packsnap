#include <util/strutil.h>

#include <math.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

char *itoa(int i) {
    int len = (int)(ceil(log10(i))+2);
    char *result = malloc(len*sizeof(char));
    snprintf(result, len, "%d", i);
    return result;
}
char *i64toa(int64_t i) {
    int len = (int)(ceil(log10(i))+2);
    char *result = malloc(len*sizeof(char));
    snprintf(result, len, "%ld", i);
    return result;
}

void clrstr(char **str) {
    if(*str != NULL) free(*str);
    *str = malloc(1 * sizeof(char));
    **str = 0;
}