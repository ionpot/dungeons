#pragma once

#include "radio_button.hpp"

#include <ionpot/widget/box.hpp>
#include <ionpot/widget/click.hpp>

#include <ionpot/util/point.hpp>

#include <optional>
#include <utility> // std::move
#include <vector>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	template<class T> // T = enum value
	class RadioGroup : public widget::Box {
	public:
		using Button = RadioButton<T>;

		RadioGroup(std::vector<Button>&& buttons):
			widget::Box {widget::sum_sizes(buttons)},
			m_buttons {std::move(buttons)},
			m_chosen {}
		{}

		std::optional<T>
		chosen() const
		{ return m_chosen; }

		std::optional<T>
		on_click(
				const widget::Click& clicked,
				util::Point offset = {})
		{
			auto pos = position() + offset;
			for (const auto& button : m_buttons) {
				if (button.value() == m_chosen)
					continue;
				if (clicked.on(button, pos)) {
					m_chosen = button.value();
					button.reset_cursor();
					return m_chosen;
				}
			}
			return {};
		}

		void
		update(util::Point offset = {})
		{
			for (auto& button : m_buttons) {
				if (button.value() != m_chosen) {
					button.update(position() + offset);
				}
			}
		}

		void
		render(util::Point offset = {}) const
		{
			auto pos = position() + offset;
			for (const auto& button : m_buttons) {
				if (button.value() == m_chosen)
					button.render_chosen(pos);
				else
					button.render_button(pos);
			}
		}

	private:
		std::vector<Button> m_buttons;
		std::optional<T> m_chosen;
	};
}
