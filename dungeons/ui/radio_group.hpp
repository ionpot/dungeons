#pragma once

#include "button.hpp"
#include "texture.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/sum_sizes.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::make_shared, std::shared_ptr
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

		using ButtonPtr = std::shared_ptr<RadioButton>;

		static std::vector<ButtonPtr>
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
			std::vector<ButtonPtr> buttons;
			for (auto&& input : inputs)
				buttons.push_back(
					std::make_shared<RadioButton>(
						ui, std::move(input), box));
			return buttons;
		}

		static std::vector<ButtonPtr>
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

		static RadioGroup
		horizontal(
				const Context& ui,
				ToString to_string,
				const std::vector<T>& values)
		{
			auto buttons = make_buttons(ui, to_string, values);
			lay_buttons(ui, buttons);
			return {std::move(buttons)};
		}

		static util::Size
		sum_sizes(const std::vector<ButtonPtr>& buttons)
		{
			std::vector<widget::Element> ls;
			for (auto button : buttons)
				ls.push_back(*button);
			return widget::sum_sizes(ls);
		}

		RadioGroup(std::vector<ButtonPtr>&& buttons):
			widget::Element {sum_sizes(buttons)},
			m_buttons {std::move(buttons)},
			m_chosen {}
		{}

		std::shared_ptr<widget::Element>
		find(util::Point point, util::Point offset = {})
		{
			for (auto button : m_buttons)
				if (widget::Element::contains(*button, point, offset))
					return button;
			return {};
		}

		std::optional<T>
		on_click(const widget::Element& clicked)
		{
			for (auto button : m_buttons) {
				if (*button == clicked) {
					button->disable();
					if (m_chosen)
						m_chosen->enable();
					m_chosen = button;
					return button->value;
				}
			}
			return {};
		}

		void
		render(util::Point offset = {}) const
		{
			for (auto button : m_buttons)
				widget::Element::render(*button, offset);
		}

	private:
		std::vector<ButtonPtr> m_buttons;
		ButtonPtr m_chosen;
	};
}
