#pragma once
#include <optional>
#include <nlohmann/json.hpp>

using namespace std;

namespace nlohmann {
    template <typename T>
    struct adl_serializer<optional<T>> {
        static void to_json(json& j, const optional<T>& opt) {
            if(opt.has_value()) {
                j = *opt;
            } else {
                j = nullptr;
            }
        }
        static void from_json(const json& j, optional<T>& opt) {
            if(j.is_null()) {
                opt = std::nullopt;
            } else {
                opt = j.get<T>();
            }
        }
    };
}