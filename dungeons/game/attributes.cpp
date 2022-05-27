#include "attributes.hpp"

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace dice = ionpot::util::dice;

	Attributes::Roll::Roll(
			dice::Engine& dice,
			const dice::Input& input
	):
		strength {dice.roll(input)},
		agility {dice.roll(input)},
		intellect {dice.roll(input)}
	{}

	Attributes::Attributes(int str, int agi, int intel):
		m_strength {str},
		m_agility {agi},
		m_intellect {intel}
	{}

	Attributes::Attributes(const Roll& rolled):
		Attributes {
			rolled.strength.total(),
			rolled.agility.total(),
			rolled.intellect.total()
		}
	{}

	int
	Attributes::strength() const
	{ return m_strength; }

	int
	Attributes::agility() const
	{ return m_agility; }

	int
	Attributes::intellect() const
	{ return m_intellect; }
}
