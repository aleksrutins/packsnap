#include <iostream>
#include <ostream>
#include <cstring>
using namespace std;

int initProject(int argc, char **argv);
int buildProject(int argc, char **argv);

void usage(char *progName) {
    cout << "Usage: " << progName << " <init|build> [args...]" << endl;
}

int main(int argc, char **argv) {
    if(argc <= 1) {
        usage(argv[0]);
        return 1;
    }
    if(!strcmp(argv[1], "init")) {
        initProject(argc - 1, argv + 1);
    } else if(!strcmp(argv[1], "build")) {
        buildProject(argc - 1, argv + 1);
    }
}