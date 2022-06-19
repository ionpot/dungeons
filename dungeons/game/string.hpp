#pragma once

#include "class.hpp"
#include "entity.hpp"

#include <string>

namespace dungeons::game::string {
	std::string armor(Entity::Armor::Id);
	std::string armor(Entity::Armor::Ptr);
	std::string armor(const Entity&);
	std::string class_id(Class::Template::Id);
	std::string class_id(Class::Template::Ptr);
	std::string class_id(const Entity&);
	std::string primary_attr(const Entity&);
	std::string secondary_attr(const Entity&);
	std::string race(Entity::Race::Id);
	std::string race(Entity::Race::Ptr);
	std::string race(const Entity&);
	std::string weapon(Entity::Weapon::Id);
	std::string weapon(Entity::Weapon::Ptr);
	std::string weapon(const Entity&);
}
