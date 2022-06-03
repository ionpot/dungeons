#include "button.hpp"

#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/solid_box.hpp>
#include <ionpot/widget/text_box.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <string>
#include <utility> // std::move

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	Texture
	button_box(const Context& ctx, util::Size content_size)
	{
		return widget::solid_box(
			ctx.renderer,
			button_size(ctx, content_size),
			ctx.button.bg_color,
			ctx.button.border
		);
	}

	util::Size
	button_size(const Context& ctx, util::Size content_size)
	{ return content_size + ctx.button.padding.size(); }

	util::Size
	button_text_size(const Context& ctx, std::string content)
	{ return ctx.bold_text_size(content); }

	SharedButton
	shared_button(
			const Context& ctx,
			std::string text,
			std::shared_ptr<const Texture> box)
	{
		return {
			ctx,
			widget::SharedTextBox {
				bold_text(ctx, text),
				box
			}
		};
	}

	UniqueButton
	unique_button(
			const Context& ctx,
			std::string btn_text)
	{
		auto text = bold_text(ctx, btn_text);
		return {
			ctx,
			widget::TextBox {
				std::move(text),
				button_box(ctx, text.size())
			}
		};
	}
}
