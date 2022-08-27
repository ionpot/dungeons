#pragma once

#include <game/entity.hpp>

#include <memory> // std::shared_ptr
#include <variant>

namespace dungeons::screen {
	struct Quit {};

	struct ToCombat {
		std::shared_ptr<game::Entity> player;
	};

	using Output = std::variant<Quit, ToCombat>;
}
