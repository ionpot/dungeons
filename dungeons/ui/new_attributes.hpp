#pragma once

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <game/attributes.hpp>
#include <game/context.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewAttributes : public widget::Element {
	public:
		using Value = game::Attributes;

		NewAttributes(
			std::shared_ptr<const Context>,
			std::shared_ptr<game::Context>);

		widget::Element* find(util::Point, util::Point offset = {});
		std::optional<Value> on_click(const widget::Element&);
		void render(util::Point offset = {}) const;

	private:
		class Labels : public widget::Element {
		public:
			Labels(std::shared_ptr<const Context>);

			void render(util::Point offset = {}) const;
			void update(const Value&);

		private:
			std::shared_ptr<const Context> m_ui;
			LabelValue m_str;
			LabelValue m_agi;
			LabelValue m_int;

			void update_size();
		};

		std::shared_ptr<game::Context> m_game;
		Button m_roll;
		Button m_reroll;
		Labels m_labels;

		Value roll();
		void update_size();
	};
}
