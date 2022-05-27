#pragma once

#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace dice = ionpot::util::dice;

	class Attributes {
	public:
		struct Roll {
			dice::Output strength;
			dice::Output agility;
			dice::Output intellect;
			Roll(dice::Engine&, const dice::Input&);
		};

		Attributes() = default;
		Attributes(int str, int agi, int intel);
		Attributes(const Roll&);

		int strength() const;
		int agility() const;
		int intellect() const;

	private:
		int m_strength {0};
		int m_agility {0};
		int m_intellect {0};
	};
}
