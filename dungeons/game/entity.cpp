#include "entity.hpp"

#include "class.hpp"

#include <ionpot/util/compare.hpp>
#include <ionpot/util/percent.hpp>

#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;

	// Attributes
	using Attributes = Entity::Attributes;

	Attributes::Attributes(int str, int agi, int intel):
		strength {str},
		agility {agi},
		intellect {intel}
	{}

	int
	Attributes::hp() const
	{ return strength; }

	int
	Attributes::initiative() const
	{ return agility + intellect; }

	util::Percent
	Attributes::dodge_chance() const
	{ return {agility}; }

	util::Percent
	Attributes::resist_chance() const
	{ return {intellect}; }

	// Entity
	Entity::Entity(std::string name):
		name {name},
		base_armor {0},
		damage {0}
	{}

	int
	Entity::agility() const
	{ return base_attr.agility + race->attr.agility; }

	util::Percent
	Entity::chance_to_get_hit() const
	{ return deflect_chance().invert(); }

	int
	Entity::compare_speed_to(const Entity& e) const
	{
		if (auto i = util::compare(e.initiative(), initiative()))
			return i;
		if (auto i = util::compare(e.agility(), agility()))
			return i;
		if (auto i = util::compare(total_armor(), e.total_armor()))
			return i;
		return 0;
	}

	int
	Entity::current_hp() const
	{ return total_hp() - damage; }

	bool
	Entity::dead() const
	{ return current_hp() <= 0; }

	util::Percent
	Entity::deflect_chance() const
	{ return {total_armor()}; }

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
	Entity::roll_damage(dice::Engine& dice) const
	{
		auto base = weapon ? dice.roll(weapon->dice) : 0;
		return base + weapon_damage_bonus();
	}

	int
	Entity::strength() const
	{ return base_attr.strength + race->attr.strength; }

	void
	Entity::take_damage(int dmg)
	{ damage += dmg; }

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
