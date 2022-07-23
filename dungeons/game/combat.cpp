#include "combat.hpp"

#include "entity.hpp"

#include <algorithm> // std::sort
#include <memory> // std::shared_ptr
#include <utility> // std::as_const

namespace dungeons::game {
	Combat::Combat(Unit player, Unit enemy):
		m_turn_order {player, enemy},
		m_round {1}
	{
		auto cmp = [&p = std::as_const(player)](
				const Unit& a,
				const Unit& b)
		{
			if (a == b)
				return true;
			if (auto i = a->compare_speed_to(*b))
				return i == -1;
			return a == p;
		};
		std::sort(m_turn_order.begin(), m_turn_order.end(), cmp);
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
