#pragma once

#include "text.hpp"

#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	struct EntityInfo : public widget::Element {
		std::shared_ptr<Text> primary;
		std::shared_ptr<Text> secondary;
		std::shared_ptr<Text> armor;
		std::shared_ptr<Text> weapon;

		EntityInfo(const Context&, const game::Entity&);
	};
}
