#include "init.hpp"

#include "game.hpp"
#include "screen.hpp"

#include <ui/config.hpp>
#include <ui/context.hpp>

#include <game/config.hpp>
#include <game/context.hpp>
#include <game/log.hpp>

#include <ionpot/sdl/base.hpp>
#include <ionpot/sdl/events.hpp>
#include <ionpot/sdl/mouse.hpp>
#include <ionpot/sdl/renderer.hpp>
#include <ionpot/sdl/ttf.hpp>
#include <ionpot/sdl/version.hpp>
#include <ionpot/sdl/video.hpp>
#include <ionpot/sdl/window.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <random> // std::random_device
#include <string>

namespace dungeons {
	namespace sdl = ionpot::sdl;

	Game
	init(
			std::shared_ptr<game::Log> log,
			const ui::Config& config,
			const game::Config& game_config,
			std::string title)
	{
		log->pair("Initialising SDL", sdl::version::as_string());
		auto base = std::make_shared<const sdl::Base>();
		auto events = std::make_shared<const sdl::Events>(base);
		auto video = std::make_shared<const sdl::Video>(base);

		log->pair("Initialising SDL_ttf", sdl::Ttf::version_str());
		auto ttf = std::make_shared<const sdl::Ttf>();

		log->write("Creating window...");
		auto window = std::make_shared<const sdl::Window>(
			video,
			sdl::Window::Config {title, config.window_size()}
		);
		log->put(window->query_size().to_str());

		log->put("Creating renderer...");
		auto renderer = std::make_shared<const sdl::Renderer>(window);

		log->put("Creating UI context...");
		auto ui = std::make_shared<const ui::Context>(ttf, renderer, config);

		log->put("Creating game context...");
		std::random_device seed;
		auto dice = std::make_shared<util::dice::Engine>(seed());
		auto game_ctx = std::make_shared<game::Context>(game_config, dice);

		log->put("Ready");
		log->endl();

		return {log, base, events, ui, game_ctx, sdl::Mouse {video}};
	}
}
