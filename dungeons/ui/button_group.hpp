#pragma once

#include "button.hpp"
#include "context.hpp"

#include <ionpot/widget/button_group.hpp>

#include <memory> // std::make_shared
#include <string>
#include <vector>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	template<class T> // T = Element
	struct ButtonGroup : public widget::ButtonGroup<T> {
		using Parent = widget::ButtonGroup<T>;

        void
        horizontal(const Context& ui)
        { Parent::horizontal(ui.button.spacing); }

        void
        left_align_text(const Context& ui)
        { Parent::left_align_text(ui.button.padding); }

        void
        vertical(const Context& ui)
        { Parent::vertical(ui.button.spacing); }
	};

	template<class T> // T = copyable value
	struct BasicButtonGroup : public ButtonGroup<ButtonWithValue<T>> {
		using Button = ButtonWithValue<T>;
		using Parent = ButtonGroup<Button>;
		using ToString = std::string (*)(T);
		using Values = std::vector<T>;

		BasicButtonGroup(
				const Context& ui,
				ToString to_str,
				const Values& values)
		{
			auto size = ui.button_text_size(to_str, values);
			for (auto value : values)
				Parent::add_button(
					std::make_shared<Button>(
						ui, to_str(value), size, value));
		}
	};

	template<class T> // T = copyable value
	struct TwoStateButtonGroup
	: public ButtonGroup<TwoStateButtonWithValue<T>> {
		using Button = TwoStateButtonWithValue<T>;
		using Parent = ButtonGroup<Button>;
		using ToString = std::string (*)(T);
		using Values = std::vector<T>;

		TwoStateButtonGroup(
				const Context& ui,
				ToString to_string,
				const Values& values)
		{
			auto text_size = ui.button_text_size(to_string, values);
			auto normal_box = TwoStateButton::make_normal_box(ui, text_size);
			auto active_box = TwoStateButton::make_active_box(ui, text_size);
			for (auto value : values) {
				auto text = to_string(value);
				Parent::add_button(
					std::make_shared<Button>(Button {
						ui,
						TwoStateButton::make_active(ui, text, active_box),
						TwoStateButton::make_normal(ui, text, normal_box),
						value
					})
				);
			}
		}
	};
}
