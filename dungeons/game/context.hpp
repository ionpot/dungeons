#pragma once

#include "config.hpp"
#include "entity.hpp"

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

		Entity::LevelUp level_up(const Entity&) const;

		Entity::Armor::Ptr pick_armor();
		Class::Template::Ptr pick_class();
		Entity::Weapon::Ptr pick_weapon();

		Entity::Attributes roll_human_attrs();
		Entity::Attributes roll_orc_attrs();

		Entity roll_enemy(const Entity& player);
		int roll_enemy_level(const Entity& player);
		void add_levels(Entity&, int max_level);
	};
}
