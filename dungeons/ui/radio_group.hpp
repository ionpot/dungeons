#pragma once

#include "button.hpp"
#include "radio_button.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/text_box.hpp>

#include <ionpot/util/size.hpp>
#include <ionpot/util/vector.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>
#include <string>
#include <utility> // std::move
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	template<class T> // T = copyable value
	class RadioGroup : public widget::Element {
	public:
		struct Input {
			std::shared_ptr<Text> active_text;
			std::shared_ptr<Text> button_text;
			T value;
			Input(const Context& ui, std::string text, T value):
				active_text {
					std::make_shared<Text>(
						ui.active_text(text))
				},
				button_text {
					std::make_shared<Text>(
						ui.bold_text(text))
				},
				value {value}
			{}
			util::Size
			text_size() const
			{
				auto size = active_text->size();
				size.pick_max(button_text->size());
				return size;
			}
		};

		using Button = RadioButton<T>;
		using Buttons = util::PtrVector<Button>;

		static Buttons
		make_buttons(
				const Context& ui,
				std::vector<Input>&& inputs)
		{
			util::Size text_size;
			for (const auto& input : inputs)
				text_size.pick_max(input.text_size());
			auto button_box = std::make_shared<const Texture>(
				ui.button_box(text_size));
			auto active_box = std::make_shared<const Texture>(
				ui.active_button_box(text_size));
			Buttons buttons;
			for (auto&& input : inputs)
				buttons.push_back(
					std::make_shared<Button>(
						ui::Button {ui, input.button_text, button_box},
						widget::TextBox {input.active_text, active_box},
						input.value));
			return buttons;
		}

		using ToString = std::string (*)(T);

		static Buttons
		make_buttons(
				const Context& ui,
				ToString to_string,
				const std::vector<T>& values)
		{
			std::vector<Input> input;
			for (auto value : values)
				input.emplace_back(ui, to_string(value), value);
			return make_buttons(ui, std::move(input));
		}

		static RadioGroup
		horizontal(
				const Context& ui,
				ToString to_string,
				const std::vector<T>& values)
		{
			auto buttons = make_buttons(ui, to_string, values);
			ui.lay_buttons(buttons);
			return {std::move(buttons)};
		}

		static RadioGroup
		vertical(
				const Context& ui,
				ToString to_string,
				const std::vector<T>& values)
		{
			auto buttons = make_buttons(ui, to_string, values);
			ui.stack_buttons(buttons);
			return {std::move(buttons)};
		}

		RadioGroup(Buttons&& buttons):
			m_buttons {std::move(buttons)}
		{
			using Ptr = std::shared_ptr<widget::Element>;
			children(util::vector_cast<Ptr>(m_buttons));
			update_size();
		}

		std::optional<T>
		on_click(const widget::Element& elmt)
		{
			for (auto& button : m_buttons) {
				if (!button->is_clicked(elmt))
					continue;
				button->choose();
				if (m_chosen)
					m_chosen->revert();
				m_chosen = button;
				return button->value();
			}
			return {};
		}

	private:
		Buttons m_buttons;
		std::shared_ptr<Button> m_chosen;
	};
}
