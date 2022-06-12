#pragma once

#include <game/class.hpp>
#include <game/entity.hpp>

#include <string>

namespace dungeons::ui::string {
	std::string class_id(game::Class::Id);
	std::string class_id(game::Class::Template::Ptr);
	std::string class_id(const game::Entity&);
	std::string primary_attr(const game::Entity&);
	std::string secondary_attr(const game::Entity&);
}
