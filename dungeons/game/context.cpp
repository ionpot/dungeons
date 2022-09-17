#include "context.hpp"

#include "armor.hpp"
#include "attributes.hpp"
#include "class.hpp"
#include "config.hpp"
#include "weapon.hpp"

#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	Context::Context(
			const Config& config,
			std::shared_ptr<dice::Engine> dice
	):
		dice {dice},
		human_attributes {config.human_attributes()},
		orc_attributes {config.orc_attributes()},
		level_up_attributes {config.level_up_attributes()},
		enemy_level_deviation {config.enemy_level_deviation()},
		armors {config.armors()},
		base_armor {config.base_armor()},
		class_templates {config.class_templates()},
		races {config.races()},
		weapons {config.weapons()},
		xp {config.xp()}
	{}

	Armor::Ptr
	Context::pick_armor() const
	{ return armors.roll(*dice); }

	Class::Template::Ptr
	Context::pick_class() const
	{ return class_templates.roll(*dice); }

	Weapon::Ptr
	Context::pick_weapon() const
	{ return weapons.roll(*dice); }

	Attributes
	Context::roll_human_attrs() const
	{ return human_attributes.roll(*dice); }

	Attributes
	Context::roll_orc_attrs() const
	{ return orc_attributes.roll(*dice); }
}
