#pragma once

#include <ionpot/util/dice.hpp>
#include <ionpot/util/exception.hpp>
#include <ionpot/util/percent.hpp>

#include <vector>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

    struct Attributes {
		IONPOT_EXCEPTION("Game::Attributes")

        enum class Id { strength, agility, intellect };

        static inline const std::vector<Id> ids
            {Id::strength, Id::agility, Id::intellect};

        static Id random_id(dice::Engine&);

        int strength {0};
        int agility {0};
        int intellect {0};

        Attributes() = default;
        Attributes(int str, int agi, int intel);

        int get(Id) const;

        int hp() const;
        int initiative() const;
        util::Percent dodge_chance() const;
        util::Percent resist_chance() const;

        int total_points() const;

        void add(Id, int = 1);

        Attributes operator+(const Attributes&) const;
        void operator+=(const Attributes&);
    };
}
