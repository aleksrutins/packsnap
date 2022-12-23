#include <fstream>
#include <iostream>
using namespace std;

int initProject(int argc, char **argv) {
    fstream config;
    config.open("packsnap.nix", ios::out);
    if(!config) {
        cout << "Failed to open packsnap.nix" << endl;
        return 1;
    }
    auto packsnapPath = "../../."; // only for examples right now
    config << R"(
{ packsnap ? import )" << packsnapPath << R"( {} }:
packsnap.lib.build { path = ./.; }
    )" << endl;
    return 0;
}