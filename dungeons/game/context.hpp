#pragma once

#include "attributes.hpp"
#include "config.hpp"

#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Context {
	public:
		Context(
				std::shared_ptr<const Config>,
				unsigned int seed);

		Attributes::Roll roll_attributes();

	private:
		util::dice::Engine m_dice_engine;
		util::dice::Input m_attribute_dice;
	};
}
