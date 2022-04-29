#include "to_string.hpp"

#include <game/class.hpp>

#include <string>

namespace dungeons::ui {
	std::string
	to_string(game::Class c)
	{
		switch (c) {
		case game::Class::warrior:
			return "Warrior";
		case game::Class::hybrid:
			return "Hybrid";
		case game::Class::mage:
			return "Mage";
		}
	}
}
