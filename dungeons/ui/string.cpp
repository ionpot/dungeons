#include "string.hpp"

#include <game/class.hpp>
#include <game/class_id.hpp>
#include <game/entity.hpp>

#include <string>

namespace dungeons::ui::string {
	std::string
	class_id(game::ClassId id)
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

	std::string
	class_id(game::Class::TemplatePtr t)
	{ return class_id(t->id); }

	std::string
	class_id(const game::Entity& e)
	{ return class_id(e.get_class().id()); }

	std::string
	primary_attr(const game::Entity& e)
	{
		const auto& attr = e.attributes();
		return "Str " + std::to_string(attr.strength())
			+ ", Agi " + std::to_string(attr.agility())
			+ ", Int " + std::to_string(attr.intellect());
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
