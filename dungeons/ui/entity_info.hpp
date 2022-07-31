#pragma once

#include "context.hpp"
#include "text.hpp"

#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	struct EntityInfo : public widget::Element {
		std::shared_ptr<const Context> ui;
		std::shared_ptr<const game::Entity> entity;
		std::shared_ptr<Text> primary;
		std::shared_ptr<Text> secondary;
		std::shared_ptr<Text> armor;
		std::shared_ptr<Text> weapon;

		EntityInfo(
			std::shared_ptr<const Context>,
			std::shared_ptr<const game::Entity>);

		void update();
	};
}
