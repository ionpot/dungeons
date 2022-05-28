#pragma once

#include "context.hpp"

namespace dungeons::game {
	class Attributes {
	public:
		Attributes() = default;
		Attributes(int str, int agi, int intel);
		Attributes(Context&);

		int strength() const;
		int agility() const;
		int intellect() const;

	private:
		int m_strength {0};
		int m_agility {0};
		int m_intellect {0};
	};
}
