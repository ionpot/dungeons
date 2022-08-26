#pragma once

#include "button_group.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	class LevelUp : public widget::Element {
	public:
		using Buttons = ButtonGroup<game::Entity::Attributes::Id>;

		LevelUp(std::shared_ptr<const Context>);

		bool done() const;

		bool on_click(const widget::Element&);

		const game::Entity::LevelUp&
			state() const;
		void state(game::Entity::LevelUp);

	private:
		std::shared_ptr<LabelValue> m_remaining;
		std::shared_ptr<Buttons> m_buttons;
		game::Entity::LevelUp m_level_up;

		void refresh();
	};
}
