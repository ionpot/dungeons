#pragma once

#include "config.hpp"
#include "entity.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Dice : public util::dice::Engine {
	public:
		using Engine = util::dice::Engine;
		using Input = util::dice::Input;

		Dice(const Config&, unsigned int seed);

		int roll_attribute();
		Entity::BaseAttributes roll_base_attr();

	private:
		Input m_attribute;
	};
}
