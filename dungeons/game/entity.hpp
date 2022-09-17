#pragma once

#include "armor.hpp"
#include "attributes.hpp"
#include "class.hpp"
#include "context.hpp"
#include "level_up.hpp"
#include "race.hpp"
#include "weapon.hpp"

#include <ionpot/util/dice.hpp>
#include <ionpot/util/percent.hpp>
#include <ionpot/util/range.hpp>

#include <optional>
#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	struct Entity {
		std::string name;
		Attributes base_attr;
		Race::Ptr race;
		Class klass;
		int base_armor;
		Armor::Ptr armor;
		Weapon::Ptr weapon;
		int damage_taken;
		int current_xp;

		Entity(std::string name);

		int strength() const;
		int agility() const;
		int intellect() const;

		int total_armor() const;

		int initiative() const;

		int current_hp() const;
		int total_hp() const;

		bool alive() const;
		bool dead() const;

		void add_xp(const Context&);

		LevelUp level_up(const Context&) const;
		void level_up(const LevelUp&);

		std::optional<LevelUp>
			try_level_up(const Context&) const;

		util::Percent chance_to_get_hit() const;
		util::Percent deflect_chance() const;
		util::Percent dodge_chance() const;
		util::Percent resist_chance() const;

		util::Range weapon_damage() const;
		int weapon_damage_bonus() const;
		int weapon_damage_min() const;
		int weapon_damage_max() const;

		int compare_speed_to(const Entity&) const;

		int roll_damage(dice::Engine&) const;

		void restore_hp();
		void take_damage(int);

		Entity roll_enemy(const Context&) const;
		int roll_enemy_level(const Context&) const;
		void add_levels(const Context&, int max_level);
	};
}
