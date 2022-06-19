#pragma once

#include "config.hpp"
#include "dice.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	struct Context {
		std::shared_ptr<Dice> dice;
		Config::Armors armors;
		int base_armor;
		Config::ClassTemplates class_templates;
		Config::Races races;
		Config::Weapons weapons;

		Context(const Config&, std::shared_ptr<Dice>);
	};
}
