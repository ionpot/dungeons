#include "entity.hpp"

#include "context.hpp"
#include "level_up.hpp"

#include <ionpot/util/compare.hpp>
#include <ionpot/util/dice.hpp>
#include <ionpot/util/percent.hpp>
#include <ionpot/util/range.hpp>

#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	Entity::Entity(std::string name):
		name {name},
		base_armor {0},
		damage_taken {0}
	{}

	void
	Entity::add_levels(const Context& game, int max_level)
	{
		while (klass.level < max_level)
		{
			auto lvup = level_up(game.level_up_attributes);
			lvup.random_attributes(*game.dice);
			level_up(lvup);
		}
	}

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

	LevelUp
	Entity::level_up(const Context& game) const
	{ return level_up(game.level_up_attributes); }

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

	Entity
	Entity::roll_enemy(const Context& game) const
	{
		Entity e {"Enemy"};
		e.base_attr = game.roll_orc_attrs();
		e.race = game.races.orc;
		e.klass.base_template = game.pick_class();
		e.base_armor = base_armor;
		e.armor = game.pick_armor();
		e.weapon = game.pick_weapon();
		e.add_levels(game, roll_enemy_level(game));
		return e;
	}

	int
	Entity::roll_enemy_level(const Context& game) const
	{
		auto range = game
			.enemy_level_deviation
			.range(klass.level);
		range.min1();
		return range.roll(*game.dice);
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
