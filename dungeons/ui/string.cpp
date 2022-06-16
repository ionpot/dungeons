#include "string.hpp"

#include <game/class.hpp>
#include <game/entity.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui::string {
	std::string
	armor(game::Entity::Armor::Id id)
	{
		switch (id) {
		case game::Entity::Armor::Id::leather:
			return "Leather";
		case game::Entity::Armor::Id::scale_mail:
			return "Scale Mail";
		}
	}

	std::string
	armor(std::shared_ptr<const game::Entity::Armor> a)
	{
		if (a)
			return armor(a->id);
		return "No Armor";
	}

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
