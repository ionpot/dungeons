#pragma once

#include "entity.hpp"

#include <ionpot/util/dice.hpp>
#include <ionpot/util/percent_roll.hpp>
#include <ionpot/util/vector.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Combat {
	public:
		using Dice = util::dice::Engine;
		using Unit = std::shared_ptr<Entity>;
		using Units = util::PtrVector<Entity>;

		struct Attack {
			enum class Result {deflected, dodged, hit};

			Unit attacker;
			Unit defender;
			util::PercentRoll hit_roll;
			std::optional<util::PercentRoll> dodge_roll;
			int damage;
			Result result;

			Attack(Dice&, Unit attacker, Unit defender);
		};

		Combat(Unit player, Unit enemy);

		Attack attack(Dice&) const;

		int round() const;
		bool new_round() const;

		Unit turn_of() const;
		void next_turn();

		bool ended() const;

	private:
		Unit m_player;
		Unit m_enemy;
		Units m_turn_order;
		Units::iterator m_current;
		int m_round;
	};
}
