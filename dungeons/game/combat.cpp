#include "combat.hpp"

#include "entity.hpp"

#include <algorithm> // std::sort
#include <memory> // std::shared_ptr

namespace dungeons::game {
	bool
	Combat::compare_speed(const Unit& a, const Unit& b)
	{
		if (a == b)
			return true;
		return a->compare_speed_to(*b) == -1;
	}

	Combat::Combat(Unit player, Unit enemy):
		m_turn_order {player, enemy},
		m_round {1}
	{
		std::sort(
			m_turn_order.begin(),
			m_turn_order.end(),
			compare_speed);
		m_current = m_turn_order.begin();
	}

	int
	Combat::current_round() const
	{ return m_round; }

	bool
	Combat::new_round() const
	{ return m_current == m_turn_order.begin(); }

	Combat::Unit
	Combat::current_turn() const
	{ return *m_current; }

	bool
	Combat::ended() const
	{
		for (const auto& entity : m_turn_order)
			if (entity->dead())
				return true;
		return false;
	}

	void
	Combat::next_turn()
	{
		++m_current;
		if (m_current == m_turn_order.end()) {
			m_current = m_turn_order.begin();
			++m_round;
		}
	}
}
