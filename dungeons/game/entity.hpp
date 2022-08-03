#pragma once

#include "class.hpp"

#include <ionpot/util/dice.hpp>
#include <ionpot/util/percent.hpp>
#include <ionpot/util/range.hpp>
#include <ionpot/util/scale.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	struct Entity {
		struct Armor {
			using Ptr = std::shared_ptr<const Armor>;
			enum class Id { leather, scale_mail } id;
			int value {0};
			int initiative {0};
			util::Scale dodge_scale;
		};

		struct Attributes {
			int strength {0};
			int agility {0};
			int intellect {0};

			Attributes() = default;
			Attributes(int str, int agi, int intel);

			int hp() const;
			int initiative() const;
			util::Percent dodge_chance() const;
			util::Percent resist_chance() const;
		};

		struct Race {
			using Ptr = std::shared_ptr<const Race>;
			enum class Id { human, orc } id;
			Attributes attr;
		};

		struct Weapon {
			using Ptr = std::shared_ptr<const Weapon>;
			enum class Id {
				dagger,
				halberd,
				longsword,
				mace
			} id;
			dice::Input dice;
			int initiative {0};
		};

		std::string name;
		Attributes base_attr;
		Race::Ptr race;
		Class klass;
		int base_armor;
		Armor::Ptr armor;
		Weapon::Ptr weapon;
		int damage_taken;

		Entity(std::string name);

		int strength() const;
		int agility() const;
		int intellect() const;

		int total_armor() const;

		int initiative() const;

		int current_hp() const;
		int total_hp() const;

		bool dead() const;

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
	};
}
