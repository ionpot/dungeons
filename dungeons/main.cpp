#include "run.hpp"

#include <dungeons/version.hpp>

#include <ui/config.hpp>

#include <game/config.hpp>

#include <ionpot/sdl/show_error.hpp>

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/exception.hpp>
#include <ionpot/util/log.hpp>

#include <exception>
#include <iostream>
#include <memory> // std::make_shared, std::shared_ptr
#include <stdlib.h> // EXIT_SUCCESS, EXIT_FAILURE

namespace {
	namespace util = ionpot::util;
	namespace sdl = ionpot::sdl;

	void
	run(std::shared_ptr<util::Log> log)
	try {
		auto title = "Dungeons v" + dungeons::version.to_string();
		log->put(title);
		log->put("Begin");
		dungeons::run(
			log,
			dungeons::ui::Config {util::CfgFile {"ui.cfg"}},
			dungeons::game::Config {util::CfgFile {"game.cfg"}},
			title
		);
		log->put("End");
	}
	catch (const util::Exception& err) {
		sdl::show_error(err.source + " Error", err.text);
		log->error(err.what());
		throw;
	}
	catch (const std::exception& err) {
		sdl::show_error("System Error", err.what());
		log->error(err.what());
		throw;
	}
}

int main()
try {
	run(std::make_shared<util::Log>("dungeons.log"));
	return EXIT_SUCCESS;
}
catch (const std::exception& err) {
	std::cerr << err.what() << std::endl;
	return EXIT_FAILURE;
}
