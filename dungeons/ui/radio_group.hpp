#pragma once

#include "button.hpp"
#include "texture.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/sum_sizes.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

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

		struct Input {
			Texture text;
			T value;
			Input(Texture&& tx, T value):
				text {std::move(tx)},
				value {value}
			{}
			Input(const Context& ui, ToString f, T value):
				Input {button_text(ui, f(value)), value}
			{}
		};

		struct RadioButton : public Button {
			T value;
			RadioButton(
					const Context& ui,
					Input&& input,
					std::shared_ptr<const Texture> box
			):
				Button {ui, std::move(input.text), box},
				value {input.value}
			{}
		};

		static std::vector<RadioButton>
		make_buttons(
				const Context& ui,
				std::vector<Input>&& inputs)
		{
			util::Size text_size;
			for (const auto& input : inputs)
				text_size.pick_max(input.text.size());
			auto box = std::make_shared<const Texture>(
				button_box(ui, text_size)
			);
			std::vector<RadioButton> buttons;
			for (auto&& input : inputs)
				buttons.emplace_back(ui, std::move(input), box);
			return buttons;
		}

		static std::vector<RadioButton>
		make_buttons(
				const Context& ui,
				ToString to_string,
				const std::vector<T>& values)
		{
			std::vector<Input> input;
			for (auto value : values)
				input.emplace_back(ui, to_string, value);
			return make_buttons(ui, std::move(input));
		}

		RadioGroup(std::vector<RadioButton>&& buttons):
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
		std::vector<RadioButton> m_buttons;
		RadioButton* m_chosen;
	};
}
