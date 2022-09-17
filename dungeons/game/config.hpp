#pragma once

#include "armor.hpp"
#include "attributes.hpp"
#include "class.hpp"
#include "race.hpp"
#include "weapon.hpp"

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
			Armor::Ptr leather;
			Armor::Ptr scale_mail;
			Armor::Ptr roll(dice::Engine&) const;
		};

		struct Attributes {
			dice::Input strength;
			dice::Input agility;
			dice::Input intellect;
			game::Attributes roll(dice::Engine&) const;
		};

		struct ClassTemplates {
			Class::Template::Ptr warrior;
			Class::Template::Ptr hybrid;
			Class::Template::Ptr mage;
			Class::Template::Ptr roll(dice::Engine&) const;
		};

		struct Races {
			Race::Ptr human;
			Race::Ptr orc;
		};

		struct Weapons {
			Weapon::Ptr dagger;
			Weapon::Ptr mace;
			Weapon::Ptr longsword;
			Weapon::Ptr halberd;
			Weapon::Ptr roll(dice::Engine&) const;
		};

		struct Xp {
			int gained_per_combat;
			int needed_for_level;
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

		Xp xp() const;

	private:
		util::CfgFile m_file;

		Attributes attributes(std::string section) const;
		Armor armor(Armor::Id, std::string) const;
		Class::Template class_template(Class::Template::Id, std::string) const;
		Race race(Race::Id, std::string) const;
		Weapon weapon(Weapon::Id, std::string) const;
	};
}
