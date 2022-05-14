#pragma once

#include "context.hpp"
#include "label_value.hpp"

#include <ionpot/widget/element.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewAttributes : public widget::Element {
	public:
		using Value = int;

		NewAttributes(std::shared_ptr<const Context>);

		void render(util::Point offset = {}) const;

		Value roll();

	private:
		std::shared_ptr<const Context> m_ui;
		Value m_value;
		LabelValue m_str;
		LabelValue m_agi;
		LabelValue m_int;

		void update_size();
		void update_text();
	};
}
