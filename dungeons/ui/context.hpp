#pragma once

#include "config.hpp"

#include <ionpot/sdl/font.hpp>
#include <ionpot/sdl/renderer.hpp>
#include <ionpot/sdl/ttf.hpp>

#include <ionpot/util/rgb.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	struct Context {
		std::shared_ptr<const sdl::Renderer> renderer;
		sdl::Font font;
		util::RGB text_color;
		Config::Button button;

		Context(
			std::shared_ptr<const sdl::Ttf>,
			std::shared_ptr<const sdl::Renderer>,
			std::shared_ptr<const Config>);

		util::Size bold_text_size(std::string) const;
	};
}
