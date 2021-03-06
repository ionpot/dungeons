#pragma once

#include "config.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/side_by_side.hpp>
#include <ionpot/widget/stack_down.hpp>

#include <ionpot/sdl/font.hpp>
#include <ionpot/sdl/renderer.hpp>
#include <ionpot/sdl/ttf.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/rgb.hpp>
#include <ionpot/util/size.hpp>
#include <ionpot/util/stringify.hpp>

#include <memory> // std::shared_ptr
#include <vector>

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	struct Context {
		std::shared_ptr<const sdl::Renderer> renderer;
		sdl::Font font;
		util::Point screen_margin;
		util::Size section_spacing;
		util::RGB text_color;
		util::Size text_spacing;
		Config::Button button;
		widget::Border active_border;
		util::RGB active_color;

		Context(
			std::shared_ptr<const sdl::Ttf>,
			std::shared_ptr<const sdl::Renderer>,
			const Config&);

		Text empty_text() const;

		template<class T>
		Text
		normal_text(T value) const
		{ return normal_text(util::stringify(value)); }

		template<>
		Text normal_text(std::string) const;

		template<class T>
		Text
		bold_text(T value) const
		{ return bold_text(util::stringify(value)); }

		template<>
		Text bold_text(std::string) const;

		Text bold_text(std::string, util::RGB) const;

		template<class T>
		Text
		active_text(T value) const
		{ return active_text(util::stringify(value)); }

		template<>
		Text active_text(std::string) const;

		util::Size bold_text_size(std::string) const;

		Texture active_button_box(util::Size content_size) const;
		Texture button_box(util::Size content_size) const;
		Text button_text(std::string content) const;
		util::Size button_size(util::Size content_size) const;

		template<class T> // T = widget::Box*[]
		void
		stack_text(const T& boxes) const
		{ widget::stack_down(boxes, text_spacing); }

		template<class T> // T = widget::Box*
		void
		lay_buttons(std::vector<T>& buttons) const
		{ widget::side_by_side(buttons, button.spacing); }

		template<class T> // T = widget::Box*
		void
		stack_buttons(std::vector<T>& buttons) const
		{ widget::stack_down(buttons, button.spacing); }
	};
}
