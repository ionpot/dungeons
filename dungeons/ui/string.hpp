#pragma once

#include <game/class.hpp>
#include <game/entity.hpp>

#include <string>

namespace dungeons::ui::string {
	std::string armor(game::Entity::Armor::Id);
	std::string armor(game::Entity::Armor::Ptr);
	std::string class_id(game::Class::Template::Id);
	std::string class_id(game::Class::Template::Ptr);
	std::string class_id(const game::Entity&);
	std::string primary_attr(const game::Entity&);
	std::string secondary_attr(const game::Entity&);
	std::string weapon(game::Entity::Weapon::Id);
	std::string weapon(game::Entity::Weapon::Ptr);
}
