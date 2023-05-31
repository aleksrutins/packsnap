#pragma once

#include "util/plan.hpp"
#include "util/app.hpp"
#include "util/env.hpp"

using namespace Packsnap::Util;

namespace Packsnap {
    class Provider {
    public:
        virtual auto Detect(App&, Environment&) -> bool = 0;
        virtual auto PlanBuild(App&, Environment&) -> BuildPlan = 0;
    };
}