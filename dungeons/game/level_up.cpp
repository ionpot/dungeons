#include "level_up.hpp"

#include "attributes.hpp"
#include "class.hpp"
#include "context.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	LevelUp::LevelUp(const Context& game, const Class& klass):
		attribute_bonus {game.level_up_attributes},
		hp_bonus {klass.hp_bonus_per_level()},
		xp_required {game.xp.needed_for_level}
	{}

	bool
	LevelUp::done() const
	{ return points_remaining() <= 0; }

	int
	LevelUp::points_remaining() const
	{ return attribute_bonus - attributes.total_points(); }

	void
	LevelUp::random_attributes(dice::Engine& dice)
	{
		while (points_remaining() > 0)
			attributes.add(Attributes::random_id(dice));
	}
}
