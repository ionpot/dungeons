#pragma once

#include "button.hpp"
#include "context.hpp"

#include <ionpot/widget/element.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::make_shared
#include <optional>
#include <string>
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	template<class T> // T = copyable value
	struct ButtonGroup : public widget::Element {
		using ToString = std::string (*)(const T&);

		struct Button : public ui::Button {
			T value;
			Button(
					const Context& ui,
					std::string text,
					util::Size content_size,
					T value
			):
				ui::Button {ui, text, content_size},
				value {value}
			{}
		};

		ButtonGroup(
				const Context& ui,
				ToString to_str,
				const std::vector<T>& values)
		{
			auto size = ui.button_text_size(to_str, values);
			for (const auto& value : values)
				add_child(
					std::make_shared<Button>(
						ui, to_str(value), size, value));
			update_size();
		}

		void
		left_align_text(const Context& ui)
		{
			for (const auto& elmt : children())
				std::static_pointer_cast<Button>(elmt)->left_align_text(ui);
		}

		std::optional<T>
		on_click(const widget::Element& clicked) const
		{
			for (const auto& elmt : children())
				if (*elmt == clicked)
					return std::static_pointer_cast<Button>(elmt)->value;
			return {};
		}

		void
		vertical(const Context& ui)
		{
			ui.stack_buttons(children());
			update_size();
		}
	};
}
