#pragma once

#include "class.hpp"
#include "entity.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Config {
	public:
		struct Armors {
			Entity::Armor::Ptr leather;
			Entity::Armor::Ptr scale_mail;
		};

		struct ClassTemplates {
			Class::Template::Ptr warrior;
			Class::Template::Ptr hybrid;
			Class::Template::Ptr mage;
		};

		struct Weapons {
			Entity::Weapon::Ptr dagger;
			Entity::Weapon::Ptr mace;
			Entity::Weapon::Ptr longsword;
			Entity::Weapon::Ptr halberd;
		};

		Config(util::CfgFile&&);

		util::dice::Input attribute_dice() const;

		int base_armor() const;
		Armors armors() const;

		ClassTemplates class_templates() const;
		Weapons weapons() const;

	private:
		util::CfgFile m_file;

		Entity::Armor armor(Entity::Armor::Id, std::string) const;
		Class::Template class_template(Class::Template::Id, std::string) const;
		Entity::Weapon weapon(Entity::Weapon::Id, std::string) const;
	};
}
