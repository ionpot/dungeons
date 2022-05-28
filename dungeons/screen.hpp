#pragma once

#include <game/class_id.hpp>

#include <variant>

namespace dungeons::screen {
	struct Quit {};

	struct ToCombat {
		game::ClassId player;
	};

	using Output = std::variant<Quit, ToCombat>;
}
