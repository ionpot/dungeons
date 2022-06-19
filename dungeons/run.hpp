#pragma once

#include <ui/config.hpp>

#include <game/config.hpp>
#include <game/log.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons {
	void run(
		std::shared_ptr<game::Log>,
		const ui::Config&,
		const game::Config&,
		std::string window_title);
}
