#include "text.hpp"

#include "context.hpp"

#include <ionpot/widget/text.hpp>

#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	Text
	normal_text(const Context& ctx, std::string text)
	{
		ctx.font.set_normal();
		return widget::text(
			ctx.renderer,
			ctx.font,
			ctx.text_color,
			text
		);
	}

	Text
	bold_text(const Context& ctx, std::string text)
	{
		ctx.font.set_bold();
		return widget::text(
			ctx.renderer,
			ctx.font,
			ctx.text_color,
			text
		);
	}
}
