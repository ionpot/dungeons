#include "context.hpp"

#include "config.hpp"

#include <ionpot/sdl/renderer.hpp>
#include <ionpot/sdl/ttf.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;

	Context::Context(
			std::shared_ptr<const sdl::Ttf> ttf,
			std::shared_ptr<const sdl::Renderer> renderer,
			std::shared_ptr<const Config> config
	):
		renderer {renderer},
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
}
