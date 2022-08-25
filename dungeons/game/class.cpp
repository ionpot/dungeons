#include "class.hpp"

namespace dungeons::game {
	int
	Class::hp_bonus() const
	{ return level * hp_bonus_per_level(); }

	int
	Class::hp_bonus_per_level() const
	{ return base_template ? base_template->hp_bonus_per_level : 0; }
}
