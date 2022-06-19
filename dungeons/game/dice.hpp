#pragma once

#include "config.hpp"
#include "entity.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Dice {
	public:
		Dice(const Config&, unsigned int seed);

		int roll_attribute();
		Entity::BaseAttributes roll_base_attr();

	private:
		util::dice::Engine m_engine;
		util::dice::Input m_attribute;
	};
}
