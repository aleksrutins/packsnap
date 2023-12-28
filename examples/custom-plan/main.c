#include <stdio.h>

#define PROJECT_NAME "packsnap-custom-plan"

int main(int argc, char **argv) {
    if(argc != 1) {
        printf("%s takes no arguments.\n", argv[0]);
        return 1;
    }
    puts("Hello, Packsnap from C!");
    return 0;
}
