#include "text.hpp"

#include "context.hpp"

#include <ionpot/widget/text.hpp>

#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	Text
	normal_text(const Context& ui, int i)
	{ return normal_text(ui, std::to_string(i)); }

	Text
	normal_text(const Context& ui, std::string text)
	{
		ui.font.set_normal();
		return widget::text(
			ui.renderer,
			ui.font,
			ui.text_color,
			text
		);
	}

	Text
	bold_text(const Context& ui, int i)
	{ return bold_text(ui, std::to_string(i)); }

	Text
	bold_text(const Context& ui, std::string text)
	{
		ui.font.set_bold();
		return widget::text(
			ui.renderer,
			ui.font,
			ui.text_color,
			text
		);
	}
}
