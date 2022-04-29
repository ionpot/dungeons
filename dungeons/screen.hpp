#pragma once

#include <game/class.hpp>

#include <variant>

namespace dungeons::screen {
	struct Quit {};

	struct ToCombat {
		game::Class player;
	};

	using Output = std::variant<Quit, ToCombat>;
}
