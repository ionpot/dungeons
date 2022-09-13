#pragma once

#include <ionpot/util/scale.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

    struct Armor {
        using Ptr = std::shared_ptr<const Armor>;
        enum class Id { leather, scale_mail } id;
        int value {0};
        int initiative {0};
        util::Scale dodge_scale;
    };
}
