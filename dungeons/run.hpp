#pragma once

#include <ui/config.hpp>

#include <game/config.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons {
	namespace util = ionpot::util;

	void run(
		std::shared_ptr<util::Log>,
		std::shared_ptr<ui::Config>,
		std::shared_ptr<const game::Config>,
		std::string window_title);
}
