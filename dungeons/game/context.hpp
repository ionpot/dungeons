#pragma once

#include "class_id.hpp"
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

		int base_armor() const;
		int hp_multiplier(ClassId) const;
		int roll_attribute();

	private:
		util::dice::Engine m_dice_engine;
		util::dice::Input m_attribute_dice;
		int m_base_armor;
		Config::HpMultipliers m_hp_multiplier;
	};
}
