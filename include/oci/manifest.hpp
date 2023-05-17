#pragma once

#include <string>
#include <map>
#include <vector>
#include <optional>

#include <util/json.hpp>
#include "descriptor.hpp"

using namespace std;

namespace Packsnap::OCI {
    struct Manifest {
        int schemaVersion;
        string mediaType;
        optional<string> artifactType;
        ContentDescriptor config;
        vector<ContentDescriptor> layers;
        optional<ContentDescriptor> subject;
        optional<map<string, string>> annotations;
    };
    NLOHMANN_DEFINE_TYPE_NON_INTRUSIVE(Manifest, schemaVersion, mediaType, artifactType, config, layers, subject, annotations)
}