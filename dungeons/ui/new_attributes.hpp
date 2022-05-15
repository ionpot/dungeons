#pragma once

#include "context.hpp"
#include "label_value.hpp"

#include <game/attributes.hpp>
#include <game/context.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewAttributes : public widget::Element {
	public:
		using Value = game::Attributes;

		NewAttributes(
			std::shared_ptr<const Context>,
			std::shared_ptr<game::Context>);

		void render(util::Point offset = {}) const;

		Value roll();

	private:
		std::shared_ptr<const Context> m_ui;
		std::shared_ptr<game::Context> m_game;
		Value m_value;
		LabelValue m_str;
		LabelValue m_agi;
		LabelValue m_int;

		void update_size();
		void update_text();
	};
}
