#include <cstdlib>
int buildProject(int argc, char **argv) {
    return system("nix-build packsnap.nix");
}