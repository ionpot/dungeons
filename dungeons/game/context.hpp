#pragma once

#include "armor.hpp"
#include "attributes.hpp"
#include "config.hpp"
#include "weapon.hpp"

#include <ionpot/util/deviation.hpp>
#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	struct Context {
		std::shared_ptr<dice::Engine> dice;
		Config::Attributes human_attributes;
		Config::Attributes orc_attributes;
		int level_up_attributes;
		util::Deviation enemy_level_deviation;
		Config::Armors armors;
		int base_armor;
		Config::ClassTemplates class_templates;
		Config::Races races;
		Config::Weapons weapons;

		Context(const Config&, std::shared_ptr<dice::Engine>);

		Armor::Ptr pick_armor() const;
		Class::Template::Ptr pick_class() const;
		Weapon::Ptr pick_weapon() const;

		Attributes roll_human_attrs() const;
		Attributes roll_orc_attrs() const;
	};
}
