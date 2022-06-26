#pragma once

#include "config.hpp"
#include "text.hpp"

#include <ionpot/widget/stack_down.hpp>

#include <ionpot/sdl/font.hpp>
#include <ionpot/sdl/renderer.hpp>
#include <ionpot/sdl/ttf.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/rgb.hpp>
#include <ionpot/util/size.hpp>
#include <ionpot/util/stringify.hpp>

#include <memory> // std::shared_ptr

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

		Context(
			std::shared_ptr<const sdl::Ttf>,
			std::shared_ptr<const sdl::Renderer>,
			const Config&);

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

		util::Size bold_text_size(std::string) const;

		template<class T> // T = widget::Box*[]
		void
		stack_text(const T& boxes) const
		{ widget::stack_down(boxes, text_spacing); }
	};
}
