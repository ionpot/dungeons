#include "string.hpp"

#include "class.hpp"
#include "entity.hpp"

#include <ionpot/util/string.hpp>

#include <string>

namespace dungeons::game::string {
	namespace util = ionpot::util;

	std::string
	armor(Entity::Armor::Id id)
	{
		switch (id) {
		case Entity::Armor::Id::leather:
			return "Leather";
		case Entity::Armor::Id::scale_mail:
			return "Scale Mail";
		}
	}

	std::string
	armor(Entity::Armor::Ptr a)
	{
		return a
			? armor(a->id)
			: "No Armor";
	}

	std::string
	class_id(Class::Template::Id id)
	{
		switch (id) {
		case Class::Template::Id::warrior:
			return "Warrior";
		case Class::Template::Id::hybrid:
			return "Hybrid";
		case Class::Template::Id::mage:
			return "Mage";
		}
	}

	std::string
	class_id(Class::Template::Ptr t)
	{ return class_id(t->id); }

	std::string
	class_id(const Entity& e)
	{ return class_id(e.get_class().get_template()); }

	std::string
	primary_attr(const Entity& e)
	{
		return "Str " + std::to_string(e.strength())
			+ ", Agi " + std::to_string(e.agility())
			+ ", Int " + std::to_string(e.intellect());
	}

	std::string
	secondary_attr(const Entity& e)
	{
		return "Hp " + std::to_string(e.total_hp())
			+ ", Armor " + std::to_string(e.armor())
			+ ", Dodge " + e.dodge_chance().to_str()
			+ ", Init " + std::to_string(e.initiative())
			+ ", Resist " + e.resist_chance().to_str();
	}

	std::string
	weapon(Entity::Weapon::Id id)
	{
		switch (id) {
		case Entity::Weapon::Id::dagger:
			return "Dagger";
		case Entity::Weapon::Id::halberd:
			return "Halberd";
		case Entity::Weapon::Id::longsword:
			return "Longsword";
		case Entity::Weapon::Id::mace:
			return "Mace";
		}
	}

	std::string
	weapon(Entity::Weapon::Ptr w)
	{
		auto p = util::string::parens;
		return w
			? weapon(w->id) + " " + p(w->dice.to_str())
			: "No Weapon";
	}
}
