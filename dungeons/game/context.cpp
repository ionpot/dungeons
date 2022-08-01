#include "context.hpp"

#include "class.hpp"
#include "config.hpp"
#include "entity.hpp"

#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr
#include <string>

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
		armors {config.armors()},
		base_armor {config.base_armor()},
		class_templates {config.class_templates()},
		races {config.races()},
		weapons {config.weapons()}
	{}

	Entity::Armor::Ptr
	Context::pick_armor()
	{ return armors.roll(*dice); }

	Class::Template::Ptr
	Context::pick_class()
	{ return class_templates.roll(*dice); }

	Entity::Weapon::Ptr
	Context::pick_weapon()
	{ return weapons.roll(*dice); }

	Entity::Attributes
	Context::roll_human_attrs()
	{ return human_attributes.roll(*dice); }

	Entity::Attributes
	Context::roll_orc_attrs()
	{ return orc_attributes.roll(*dice); }

	Entity
	Context::roll_orc(std::string name)
	{
		Entity e {name};
		e.base_attr = roll_orc_attrs();
		e.race = races.orc;
		e.klass.base_template = pick_class();
		e.base_armor = base_armor;
		e.armor = pick_armor();
		e.weapon = pick_weapon();
		return e;
	}
}
