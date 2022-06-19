#pragma once

#include "entity.hpp"

#include <ionpot/util/log.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	struct Log : public util::Log {
		using util::Log::Log;
		void entity(const Entity&);
	};
}
