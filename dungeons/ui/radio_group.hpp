#pragma once

#include "button.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/sum_sizes.hpp>

#include <ionpot/util/point.hpp>

#include <optional>
#include <string>
#include <utility> // std::move
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	template<class T> // T = enum value
	class RadioGroup : public widget::Element {
	public:
		using ToString = std::string (*)(T);

		struct Button : public SharedButton {
			T value;
			Button(SharedButton&& button, T value):
				SharedButton {std::move(button)},
				value {value}
			{}
		};

		struct Input {
			std::string text;
			T value;
			Input(ToString f, T value):
				text {f(value)},
				value {value}
			{}
		};

		static std::vector<Button>
		make_buttons(
				const Context& ui,
				const std::vector<Input>& inputs)
		{
			util::Size text_size;
			for (const auto& input : inputs)
				text_size.pick_max(button_text_size(ui, input.text));
			auto box = std::make_shared<const Texture>(
				button_box(ui, text_size)
			);
			std::vector<Button> buttons;
			for (auto [text, value] : inputs)
				buttons.emplace_back(shared_button(ui, text, box), value);
			return buttons;
		}

		static std::vector<Button>
		make_buttons(
				const Context& ui,
				ToString to_string,
				const std::vector<T>& values)
		{
			std::vector<Input> input;
			for (auto value : values)
				input.emplace_back(to_string, value);
			return make_buttons(ui, input);
		}

		RadioGroup(std::vector<Button>&& buttons):
			widget::Element {widget::sum_sizes(buttons)},
			m_buttons {std::move(buttons)},
			m_chosen {nullptr}
		{}

		widget::Element*
		find(util::Point point, util::Point offset = {})
		{
			for (auto& button : m_buttons)
				if (widget::Element::contains(button, point, offset))
					return &button;
			return nullptr;
		}

		std::optional<T>
		on_click(const widget::Element& clicked)
		{
			for (auto& button : m_buttons) {
				if (button == clicked) {
					button.disable();
					if (m_chosen)
						m_chosen->enable();
					m_chosen = &button;
					return button.value;
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
