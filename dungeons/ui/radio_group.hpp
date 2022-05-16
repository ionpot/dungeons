#pragma once

#include "radio_button.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/sum_sizes.hpp>

#include <ionpot/util/point.hpp>

#include <optional>
#include <utility> // std::move
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	template<class T> // T = enum value
	class RadioGroup : public widget::Element {
	public:
		using Button = RadioButton<T>;

		RadioGroup(std::vector<Button>&& buttons):
			widget::Element {widget::sum_sizes(buttons)},
			m_buttons {std::move(buttons)},
			m_chosen {}
		{}

		widget::Element*
		find(util::Point point, util::Point offset = {})
		{
			for (auto& button : m_buttons)
				if (auto found = widget::Element::find(button, point, offset))
					return found;
			return nullptr;
		}

		std::optional<T>
		on_click(const widget::Element& clicked)
		{
			for (auto& button : m_buttons) {
				if (button.is_click(clicked)) {
					button.set();
					if (m_chosen)
						m_chosen->reset();
					m_chosen = &button;
					return button.value();
				}
			}
			return {};
		}

		void
		render(util::Point offset = {}) const
		{
			for (const auto& button : m_buttons)
				widget::Element::render(button, offset);
		}

	private:
		std::vector<Button> m_buttons;
		Button* m_chosen;
	};
}
