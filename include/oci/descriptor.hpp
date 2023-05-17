#pragma once

#include <string>
#include <vector>
#include <map>
#include <optional>
#include <cstdint>

#include <util/json.hpp>

using namespace std;

namespace Packsnap::OCI {
    struct ContentDescriptor {
        string mediaType;
        string digest;
        int64_t size;
        optional<vector<string>> urls;
        optional<map<string, string>> annotations;
        optional<string> data;
        optional<string> artifactType;
    };
    NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(ContentDescriptor, mediaType, digest, size, urls, annotations, data, artifactType)
}