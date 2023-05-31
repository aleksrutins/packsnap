#pragma once

#include <string>
#include <filesystem>
#include <optional>
#include <fstream>

#include <nlohmann/json.hpp>

using json = nlohmann::json;

using namespace std;
namespace fs = std::filesystem;

namespace Packsnap::Util {
    class App {
        fs::path path;
    public:
        App(fs::path path) : path(path) {}
        auto ReadFile(string name) -> optional<string> {
            auto filePath = path.concat(name);
            if(!fs::exists(filePath)) return nullopt;
            ifstream file(path.concat(name));
            string result;
            string buf;
            do {
                getline(file, buf);
                result += buf;
            } while(!file.eof());
            return result;
        }

        auto ReadJson(string name) -> optional<json> {
            auto text = ReadFile(name);
            if(text.has_value()) return json::parse(*text);
            else return nullopt;
        }
    };
}