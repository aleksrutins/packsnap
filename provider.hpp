#pragma once

#include "util/plan.hpp"

using namespace Packsnap::Util;

namespace Packsnap {
    class Provider {
    public:
        virtual auto Detect() -> bool = 0;
        virtual auto PlanBuild() -> BuildPlan = 0;
    };
}