#include "class.hpp"

namespace dungeons::game {
	int
	Class::hp_bonus() const
	{ return base_template ? level * base_template->hp_bonus_per_level : 0; }
}
