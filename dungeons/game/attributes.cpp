#include "attributes.hpp"

#include "context.hpp"

namespace dungeons::game {
	Attributes::Attributes(int str, int agi, int intel):
		m_strength {str},
		m_agility {agi},
		m_intellect {intel}
	{}

	Attributes::Attributes(Context& game):
		Attributes {
			game.roll_attribute(),
			game.roll_attribute(),
			game.roll_attribute()
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
