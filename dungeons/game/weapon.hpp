#pragma once

#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

    struct Weapon {
        using Ptr = std::shared_ptr<const Weapon>;
        enum class Id {
            dagger,
            halberd,
            longsword,
            mace
        } id;
        dice::Input dice;
        int initiative {0};
    };
}
