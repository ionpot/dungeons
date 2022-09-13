#include "attributes.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

    // static
	Attributes::Id
	Attributes::random_id(dice::Engine& dice)
	{ return dice.pick(Attributes::ids); }

    // constructor
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
}
