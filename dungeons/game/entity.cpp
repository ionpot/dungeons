#include "entity.hpp"

#include "class.hpp"

#include <ionpot/util/percent.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	// BaseAttributes
	using BaseAttributes = Entity::BaseAttributes;

	BaseAttributes::BaseAttributes(int str, int agi, int intel):
		strength {str},
		agility {agi},
		intellect {intel}
	{}

	int
	BaseAttributes::hp() const
	{ return strength; }

	int
	BaseAttributes::initiative() const
	{ return agility + intellect; }

	util::Percent
	BaseAttributes::dodge_chance() const
	{ return {agility}; }

	util::Percent
	BaseAttributes::resist_chance() const
	{ return {intellect}; }

	// Entity
	Entity::Entity(
			Race::Ptr race,
			Class::Template::Ptr class_template,
			int base_armor
	):
		race {race},
		klass {class_template},
		base_armor {base_armor}
	{}

	int
	Entity::agility() const
	{ return base_attr.agility + race->attr.agility; }

	util::Percent
	Entity::dodge_chance() const
	{
		auto total = base_attr.dodge_chance()
			+ race->attr.dodge_chance();
		return armor
			? armor->dodge_scale.apply_to(total)
			: total;
	}

	int
	Entity::initiative() const
	{
		return base_attr.initiative()
			+ race->attr.initiative()
			+ (armor ? armor->initiative : 0)
			+ (weapon ? weapon->initiative : 0);
	}

	int
	Entity::intellect() const
	{ return base_attr.intellect + race->attr.intellect; }

	util::Percent
	Entity::resist_chance() const
	{
		return base_attr.resist_chance()
			+ race->attr.resist_chance();
	}

	int
	Entity::strength() const
	{ return base_attr.strength + race->attr.strength; }

	int
	Entity::total_armor() const
	{ return base_armor + (armor ? armor->value : 0); }

	int
	Entity::total_hp() const
	{
		return base_attr.hp()
			+ race->attr.hp()
			+ klass.hp_bonus();
	}

	util::Range
	Entity::weapon_damage() const
	{ return {weapon_damage_min(), weapon_damage_max()}; }

	int
	Entity::weapon_damage_bonus() const
	{ return strength() / 2; }

	int
	Entity::weapon_damage_min() const
	{
		return weapon
			? weapon->dice.min() + weapon_damage_bonus()
			: 0;
	}

	int
	Entity::weapon_damage_max() const
	{
		return weapon
			? weapon->dice.max() + weapon_damage_bonus()
			: 0;
	}
}
