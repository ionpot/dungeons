#include "to_string.hpp"

#include <game/class_id.hpp>

#include <string>

namespace dungeons::ui {
	std::string
	to_string(game::ClassId id)
	{
		switch (id) {
		case game::ClassId::warrior:
			return "Warrior";
		case game::ClassId::hybrid:
			return "Hybrid";
		case game::ClassId::mage:
			return "Mage";
		}
	}
}
