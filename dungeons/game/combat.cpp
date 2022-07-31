#include "combat.hpp"

#include <ionpot/util/percent_roll.hpp>

#include <algorithm> // std::sort
#include <utility> // std::as_const

namespace dungeons::game {
	namespace util = ionpot::util;

	Combat::Attack::Attack(Dice& dice, Unit atk, Unit def):
		attacker {atk},
		defender {def},
		hit_roll {defender->chance_to_get_hit(), dice},
		damage {0},
		result {Result::deflected}
	{
		if (hit_roll.fail())
			return;
		dodge_roll = util::PercentRoll {
			defender->dodge_chance(), dice};
		if (dodge_roll->success()) {
			result = Result::dodged;
			return;
		}
		damage = attacker->roll_damage(dice);
		defender->take_damage(damage);
		result = Result::hit;
	}

	// Combat
	Combat::Combat(
			Unit player,
			Unit enemy
	):
		m_player {player},
		m_enemy {enemy},
		m_turn_order {m_player, m_enemy},
		m_round {1}
	{
		auto cmp = [&p = std::as_const(m_player)](
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

	Combat::Attack
	Combat::attack(Dice& dice) const
	{
		auto attacker = *m_current;
		auto defender = attacker == m_player ? m_enemy : m_player;
		return {dice, attacker, defender};
	}

	bool
	Combat::ended() const
	{
		for (const auto& entity : m_turn_order)
			if (entity->dead())
				return true;
		return false;
	}

	bool
	Combat::new_round() const
	{ return m_current == m_turn_order.begin(); }

	void
	Combat::next_turn()
	{
		++m_current;
		if (m_current == m_turn_order.end()) {
			m_current = m_turn_order.begin();
			++m_round;
		}
	}

	int
	Combat::round() const
	{ return m_round; }

	Combat::Unit
	Combat::turn_of() const
	{ return *m_current; }
}
