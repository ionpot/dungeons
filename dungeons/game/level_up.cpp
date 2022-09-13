#include "level_up.hpp"

#include "attributes.hpp"
#include "class.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	LevelUp::LevelUp(const Class& c, int attr_points):
		attribute_bonus {attr_points},
		hp_bonus {c.hp_bonus_per_level()}
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
