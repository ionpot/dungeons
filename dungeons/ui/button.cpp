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
	button_box(const Context& ctx, util::Size box_size)
	{
		return widget::solid_box(
			ctx.renderer,
			box_size,
			ctx.button.bg_color,
			ctx.button.border
		);
	}

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
		auto box_size = text.size() + ctx.button.padding.size();
		return {
			ctx,
			widget::TextBox {
				std::move(text),
				button_box(ctx, box_size)
			}
		};
	}
}
