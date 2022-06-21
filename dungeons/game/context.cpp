#include "context.hpp"

#include "class.hpp"
#include "config.hpp"
#include "dice.hpp"
#include "entity.hpp"

#include <memory> // std::shared_ptr
#include <vector>

namespace dungeons::game {
	Context::Context(const Config& config, std::shared_ptr<Dice> dice):
		dice {dice},
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

	Entity
	Context::roll_orc()
	{
		return {
			dice->roll_base_attr(),
			races.orc,
			pick_class(),
			base_armor,
			pick_armor(),
			pick_weapon()
		};
	}
}
