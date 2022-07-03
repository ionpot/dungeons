#pragma once

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <game/context.hpp>
#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	class NewAttributes : public widget::Element {
	public:
		using Value = game::Entity::Attributes;

		NewAttributes(
			std::shared_ptr<const Context>,
			std::shared_ptr<game::Context>);

		bool is_clicked(const widget::Element&);

		Value roll();

	private:
		class Labels : public widget::Element {
		public:
			Labels(std::shared_ptr<const Context>);

			void update(const Value&);

		private:
			std::shared_ptr<LabelValue> m_str;
			std::shared_ptr<LabelValue> m_agi;
			std::shared_ptr<LabelValue> m_int;
		};

		std::shared_ptr<game::Context> m_game;
		std::shared_ptr<Button> m_roll;
		std::shared_ptr<Button> m_reroll;
		std::shared_ptr<Labels> m_labels;
	};
}
