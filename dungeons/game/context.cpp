#include "context.hpp"

#include "class.hpp"
#include "config.hpp"
#include "entity.hpp"

#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr
#include <vector>

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
	{
		return dice->pick(std::vector {
			armors.leather,
			armors.scale_mail
		});
	}

	Class::Template::Ptr
	Context::pick_class()
	{
		return dice->pick(std::vector {
			class_templates.warrior,
			class_templates.hybrid,
			class_templates.mage
		});
	}

	Entity::Weapon::Ptr
	Context::pick_weapon()
	{
		return dice->pick(std::vector {
			weapons.dagger,
			weapons.mace,
			weapons.longsword,
			weapons.halberd
		});
	}

	Entity::Attributes
	Context::roll_human_attrs()
	{ return human_attributes.roll(*dice); }

	Entity::Attributes
	Context::roll_orc_attrs()
	{ return orc_attributes.roll(*dice); }

	Entity
	Context::roll_orc()
	{
		return {
			roll_orc_attrs(),
			races.orc,
			pick_class(),
			base_armor,
			pick_armor(),
			pick_weapon()
		};
	}
}
