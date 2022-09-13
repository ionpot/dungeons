#pragma once

#include "armor.hpp"
#include "attributes.hpp"
#include "class.hpp"
#include "combat.hpp"
#include "entity.hpp"
#include "level_up.hpp"
#include "race.hpp"
#include "weapon.hpp"

#include <ionpot/util/percent_roll.hpp>

#include <string>
#include <vector>

namespace dungeons::game::string {
	namespace util = ionpot::util;

	using Lines = std::vector<std::string>;

	std::string armor(Armor::Id);
	std::string armor(Armor::Ptr);
	std::string armor(const Entity&);

	Lines attack(const Combat::Attack&);
	std::string attack_result(const Combat::Attack&);

	std::string attribute(Attributes::Id);
	std::string attribute_short(Attributes::Id);

	std::string attribute_bonus(Attributes::Id, int);
	std::string attribute_bonus(const Attributes&);

	std::string class_id(Class::Template::Id);
	std::string class_id(Class::Template::Ptr);
	std::string class_id(const Entity&);

	std::string class_level(const Entity&);

	std::string level_up(const LevelUp&);

	std::string percent_roll(const util::PercentRoll&);

	std::string primary(const Entity& e);
	std::string primary_attr(const Entity&);
	std::string secondary_attr(const Entity&);

	std::string race(Race::Id);
	std::string race(Race::Ptr);
	std::string race(const Entity&);

	std::string round(int);

	std::string takes_damage(const Entity&, int dmg);

	std::string weapon_attack(const Combat::Attack&);

	std::string weapon_damage(const Entity&);

	std::string weapon_dice(Weapon::Ptr);
	std::string weapon_dice(const Entity&);

	std::string weapon_info(Weapon::Ptr);
	std::string weapon_info(const Entity&);

	std::string weapon_name(Weapon::Id);
	std::string weapon_name(Weapon::Ptr);
	std::string weapon_name(const Entity&);
}
