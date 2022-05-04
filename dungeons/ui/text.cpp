#include "text.hpp"

#include "context.hpp"

#include <ionpot/widget/text.hpp>

#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	Text
	normal_text(const Context& ctx, int i)
	{ return normal_text(ctx, std::to_string(i)); }

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
	bold_text(const Context& ctx, int i)
	{ return bold_text(ctx, std::to_string(i)); }

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
