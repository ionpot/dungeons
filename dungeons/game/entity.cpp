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

	void
	Attributes::add(Id id, int i)
	{
		switch (id) {
		case Id::strength:
			strength += i;
			return;
		case Id::agility:
			agility += i;
			return;
		case Id::intellect:
			intellect += i;
			return;
		}
		throw Exception {"Invalid id in Attributes::add()."};
	}

	int
	Attributes::get(Id id) const
	{
		switch (id) {
		case Id::strength:
			return strength;
		case Id::agility:
			return agility;
		case Id::intellect:
			return intellect;
		}
		throw Exception {"Invalid id in Attributes::get()."};
	}

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

	int
	Attributes::total_points() const
	{ return strength + agility + intellect; }

	Attributes
	Attributes::operator+(const Attributes& a) const
	{
		return {
			strength + a.strength,
			agility + a.agility,
			intellect + a.intellect
		};
	}

	void
	Attributes::operator+=(const Attributes& a)
	{ *this = *this + a; }

	// LevelUp
	using LevelUp = Entity::LevelUp;

	LevelUp::LevelUp(const Class& c, int attr_points):
		attribute_bonus {attr_points},
		hp_bonus {c.hp_bonus_per_level()}
	{}

	bool
	LevelUp::done() const
	{ return points_remaining() <= 0; }

	int
	LevelUp::points_remaining() const
	{ return attribute_bonus - attributes.total_points(); }

	// Entity
	Entity::Entity(std::string name):
		name {name},
		base_armor {0},
		damage_taken {0}
	{}

	bool
	Entity::alive() const
	{ return current_hp() > 0; }

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
	{ return total_hp() - damage_taken; }

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

	LevelUp
	Entity::level_up(int attr_points) const
	{ return {klass, attr_points}; }

	void
	Entity::level_up(const LevelUp& lvup)
	{
		base_attr += lvup.attributes;
		++klass.level;
	}

	util::Percent
	Entity::resist_chance() const
	{
		return base_attr.resist_chance()
			+ race->attr.resist_chance();
	}

	void
	Entity::restore_hp()
	{ damage_taken = 0; }

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
	{ damage_taken += dmg; }

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
