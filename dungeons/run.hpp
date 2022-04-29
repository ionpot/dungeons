#pragma once

#include <ui/config.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons {
	namespace util = ionpot::util;

	void run(
		std::shared_ptr<util::Log>,
		std::shared_ptr<ui::Config>,
		std::string window_title);
}
