#include "context.hpp"

#include "config.hpp"

#include <ionpot/sdl/mouse.hpp>
#include <ionpot/sdl/renderer.hpp>
#include <ionpot/sdl/system_cursor.hpp>
#include <ionpot/sdl/ttf.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::make_shared, std::shared_ptr

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;
	namespace widget = ionpot::widget;

	Context::Context(
			std::shared_ptr<const sdl::Ttf> ttf,
			std::shared_ptr<const sdl::Renderer> renderer,
			std::shared_ptr<sdl::Mouse> mouse,
			std::shared_ptr<widget::LeftClick> left_click,
			std::shared_ptr<const Config> config
	):
		renderer {renderer},
		mouse {mouse},
		left_click {left_click},
		cursor_arrow {std::make_shared<sdl::SystemCursor::Arrow>()},
		cursor_hand {std::make_shared<sdl::SystemCursor::Hand>()},
		font {ttf, config->font()},
		text_color {config->text_color()},
		button {config->button()}
	{}

	util::Size
	Context::bold_text_size(std::string text) const
	{
		font.set_bold();
		return font.calculate_size(text);
	}

	void
	Context::reset_cursor() const
	{
		cursor_arrow->set();
	}
}
