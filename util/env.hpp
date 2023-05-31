#pragma once

#include <map>
#include <string>
#include <optional>

using namespace std;

namespace Packsnap::Util {
    class Environment {
        map<string, string> overrides;
    public:
        Environment(map<string, string> overrides) : overrides(overrides) {}

        auto Get(string key) -> optional<string> {
            if(overrides.find(key) != overrides.end())
                return overrides[key];
            else if(getenv(key.c_str()) != nullptr)
                return getenv(key.c_str());
            else
                return nullopt;
        }

        auto GetConfig(string key) -> optional<string> {
            return Get("PACKSNAP_" + key);
        }
    };
}