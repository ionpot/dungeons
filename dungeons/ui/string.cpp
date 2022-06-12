#include "string.hpp"

#include <game/class.hpp>
#include <game/entity.hpp>

#include <string>

namespace dungeons::ui::string {
	std::string
	class_id(game::Class::Id id)
	{
		switch (id) {
		case game::Class::Id::warrior:
			return "Warrior";
		case game::Class::Id::hybrid:
			return "Hybrid";
		case game::Class::Id::mage:
			return "Mage";
		}
	}

	std::string
	class_id(game::Class::Template::Ptr t)
	{ return class_id(t->id); }

	std::string
	class_id(const game::Entity& e)
	{ return class_id(e.get_class().id()); }

	std::string
	primary_attr(const game::Entity& e)
	{
		return "Str " + std::to_string(e.strength())
			+ ", Agi " + std::to_string(e.agility())
			+ ", Int " + std::to_string(e.intellect());
	}

	std::string
	secondary_attr(const game::Entity& e)
	{
		return "Hp " + std::to_string(e.total_hp())
			+ ", Armor " + std::to_string(e.armor())
			+ ", Dodge " + e.dodge_chance().to_str()
			+ ", Init " + std::to_string(e.initiative())
			+ ", Resist " + e.resist_chance().to_str();
	}
}
