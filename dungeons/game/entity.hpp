#pragma once

#include "class.hpp"

#include <ionpot/util/dice.hpp>
#include <ionpot/util/percent.hpp>
#include <ionpot/util/range.hpp>
#include <ionpot/util/scale.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

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
			util::dice::Input dice;
			int initiative {0};
		};

		Attributes base_attr;
		Race::Ptr race;
		Class klass;
		int base_armor;
		Armor::Ptr armor;
		Weapon::Ptr weapon;

		Entity(
			Attributes,
			Race::Ptr,
			Class::Template::Ptr,
			int base_armor,
			Armor::Ptr,
			Weapon::Ptr);

		int strength() const;
		int agility() const;
		int intellect() const;

		int total_armor() const;

		int initiative() const;
		int total_hp() const;

		util::Percent dodge_chance() const;
		util::Percent resist_chance() const;

		util::Range weapon_damage() const;
		int weapon_damage_bonus() const;
		int weapon_damage_min() const;
		int weapon_damage_max() const;
	};
}
