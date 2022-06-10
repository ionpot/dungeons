#pragma once

#include <game/class.hpp>
#include <game/class_id.hpp>
#include <game/entity.hpp>

#include <string>

namespace dungeons::ui::string {
	std::string class_id(game::ClassId);
	std::string class_id(game::Class::TemplatePtr);
	std::string class_id(const game::Entity&);
	std::string primary_attr(const game::Entity&);
	std::string secondary_attr(const game::Entity&);
}
