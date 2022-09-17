#pragma once

#include "attributes.hpp"
#include "class.hpp"
#include "context.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

    struct LevelUp {
        Attributes attributes;
        int attribute_bonus {0};
        int hp_bonus {0};
        int xp_required {0};

        LevelUp() = default;
        LevelUp(const Context&, const Class&);

        bool done() const;
        int points_remaining() const;

        void random_attributes(dice::Engine&);
    };
}
