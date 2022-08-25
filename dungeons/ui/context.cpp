#include "context.hpp"

#include "config.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/solid_box.hpp>
#include <ionpot/widget/text.hpp>

#include <ionpot/sdl/renderer.hpp>
#include <ionpot/sdl/ttf.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	Context::Context(
			std::shared_ptr<const sdl::Ttf> ttf,
			std::shared_ptr<const sdl::Renderer> renderer,
			const Config& config
	):
		renderer {renderer},
		font {ttf, config.font()},
		screen_margin {config.screen_margin()},
		section_spacing {config.section_spacing()},
		text_color {config.text_color()},
		text_spacing {config.text_spacing()},
		button {config.button()},
		active_border {config.active_border()},
		active_color {config.active_color()}
	{}
	
	Text
	Context::active_text(std::string text) const
	{ return bold_text(text, active_color); }
	
	Text
	Context::bold_text(std::string text) const
	{ return bold_text(text, text_color); }

	Text
	Context::bold_text(std::string text, util::RGB color) const
	{
		font.set_bold();
		return widget::text(renderer, font, color, text);
	}

	util::Size
	Context::bold_text_size(std::string text) const
	{
		font.set_bold();
		return font.calculate_size(text);
	}

	Text
	Context::empty_text() const
	{ return normal_text(" "); }
	
	Text
	Context::normal_text(std::string text) const
	{
		font.set_normal();
		return widget::text(renderer, font, text_color, text);
	}

	Texture
	Context::active_button_box(util::Size content_size) const
	{
		return widget::solid_box(
			renderer,
			button_size(content_size),
			button.bg_color,
			active_border
		);
	}

	Texture
	Context::button_box(util::Size content_size) const
	{
		return widget::solid_box(
			renderer,
			button_size(content_size),
			button.bg_color,
			button.border
		);
	}

	util::Size
	Context::button_size(util::Size content_size) const
	{ return content_size + button.padding.size(); }

	Text
	Context::button_text(std::string content) const
	{ return bold_text(content); }

	util::Size
	Context::button_text_size(std::string content) const
	{ return bold_text_size(content); }
}
