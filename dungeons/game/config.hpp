#pragma once

#include "class.hpp"
#include "entity.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/deviation.hpp>
#include <ionpot/util/dice.hpp>

#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	class Config {
	public:
		struct Armors {
			Entity::Armor::Ptr leather;
			Entity::Armor::Ptr scale_mail;
			Entity::Armor::Ptr roll(dice::Engine&) const;
		};

		struct Attributes {
			dice::Input strength;
			dice::Input agility;
			dice::Input intellect;
			Entity::Attributes roll(dice::Engine&) const;
		};

		struct ClassTemplates {
			Class::Template::Ptr warrior;
			Class::Template::Ptr hybrid;
			Class::Template::Ptr mage;
			Class::Template::Ptr roll(dice::Engine&) const;
		};

		struct Races {
			Entity::Race::Ptr human;
			Entity::Race::Ptr orc;
		};

		struct Weapons {
			Entity::Weapon::Ptr dagger;
			Entity::Weapon::Ptr mace;
			Entity::Weapon::Ptr longsword;
			Entity::Weapon::Ptr halberd;
			Entity::Weapon::Ptr roll(dice::Engine&) const;
		};

		Config(util::CfgFile&&);

		Attributes human_attributes() const;
		Attributes orc_attributes() const;

		int base_armor() const;
		Armors armors() const;

		util::Deviation enemy_level_deviation() const;

		int level_up_attributes() const;

		ClassTemplates class_templates() const;
		Races races() const;
		Weapons weapons() const;

	private:
		util::CfgFile m_file;

		Attributes attributes(std::string section) const;
		Entity::Armor armor(Entity::Armor::Id, std::string) const;
		Class::Template class_template(Class::Template::Id, std::string) const;
		Entity::Race race(Entity::Race::Id, std::string) const;
		Entity::Weapon weapon(Entity::Weapon::Id, std::string) const;
	};
}
