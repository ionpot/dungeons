#pragma once

#include "attributes.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
    struct Race {
        using Ptr = std::shared_ptr<const Race>;
        enum class Id { human, orc } id;
        Attributes attr;
    };
}
