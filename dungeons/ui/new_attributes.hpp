#pragma once

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <ionpot/widget/element.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewAttributes : public widget::Element {
	public:
		using Value = int;

		NewAttributes(std::shared_ptr<const Context>);

		widget::Element* find(util::Point, util::Point offset = {});

		std::optional<Value> on_click(const widget::Element&);

		void render(util::Point offset = {}) const;

	private:
		std::shared_ptr<const Context> m_ui;
		std::optional<Value> m_value;
		UniqueButton m_reroll;
		LabelValue m_str;
		LabelValue m_agi;
		LabelValue m_int;

		void update_size();
		void update_value();
	};
}
