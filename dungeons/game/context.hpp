#pragma once

#include "attributes.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Context {
	public:
		Context(unsigned int seed);

		Attributes::Roll roll_attributes();

	private:
		util::dice::Engine m_dice_engine;
		util::dice::Input m_attribute_dice;
	};
}
