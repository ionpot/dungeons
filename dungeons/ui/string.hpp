#pragma once

#include <game/class.hpp>
#include <game/entity.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui::string {
	std::string armor(game::Entity::Armor::Id);
	std::string armor(std::shared_ptr<const game::Entity::Armor>);
	std::string class_id(game::Class::Id);
	std::string class_id(game::Class::Template::Ptr);
	std::string class_id(const game::Entity&);
	std::string primary_attr(const game::Entity&);
	std::string secondary_attr(const game::Entity&);
}
