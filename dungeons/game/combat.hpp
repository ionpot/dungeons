#pragma once

#include "entity.hpp"

#include <ionpot/util/vector.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Combat {
	public:
		using Unit = std::shared_ptr<Entity>;
		using Units = util::PtrVector<Entity>;

		Combat(Unit player, Unit enemy);

		int current_round() const;
		bool new_round() const;

		Unit current_turn() const;
		void next_turn();

		bool ended() const;

	private:
		Units m_turn_order;
		Units::iterator m_current;
		int m_round;

		static bool compare_speed(const Unit&, const Unit&);
	};
}
