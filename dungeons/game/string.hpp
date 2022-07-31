#pragma once

#include "class.hpp"
#include "combat.hpp"
#include "entity.hpp"

#include <ionpot/util/percent_roll.hpp>

#include <string>
#include <vector>

namespace dungeons::game::string {
	namespace util = ionpot::util;

	using Lines = std::vector<std::string>;

	std::string armor(Entity::Armor::Id);
	std::string armor(Entity::Armor::Ptr);
	std::string armor(const Entity&);

	Lines attack(const Combat::Attack&);
	std::string attack_result(const Combat::Attack&);

	std::string class_id(Class::Template::Id);
	std::string class_id(Class::Template::Ptr);
	std::string class_id(const Entity&);

	std::string percent_roll(const util::PercentRoll&);

	std::string primary(const Entity& e);
	std::string primary_attr(const Entity&);
	std::string secondary_attr(const Entity&);

	std::string race(Entity::Race::Id);
	std::string race(Entity::Race::Ptr);
	std::string race(const Entity&);

	std::string round(int);

	std::string takes_damage(const Entity&, int dmg);

	std::string weapon(Entity::Weapon::Id);
	std::string weapon(Entity::Weapon::Ptr);
	std::string weapon(const Entity&);
	std::string weapon_attack(const Combat::Attack&);
}
