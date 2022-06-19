#pragma once

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <game/dice.hpp>
#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/group.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewAttributes : public widget::Group {
	public:
		using Value = game::Entity::BaseAttributes;

		NewAttributes(
			std::shared_ptr<const Context>,
			std::shared_ptr<game::Dice>);

		std::optional<Value> on_click(const widget::Element&);

	private:
		class Labels : public widget::Group {
		public:
			Labels(std::shared_ptr<const Context>);

			void update(const Value&);

		private:
			std::shared_ptr<LabelValue> m_str;
			std::shared_ptr<LabelValue> m_agi;
			std::shared_ptr<LabelValue> m_int;
		};

		std::shared_ptr<game::Dice> m_dice;
		std::shared_ptr<Button> m_roll;
		std::shared_ptr<Button> m_reroll;
		std::shared_ptr<Labels> m_labels;

		Value roll();
	};
}
