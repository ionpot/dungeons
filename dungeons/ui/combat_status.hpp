#pragma once

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	class CombatStatus : public widget::Element {
	public:
		CombatStatus(std::shared_ptr<const Context>);

		void round(int);
		void player_turn();
		void enemy_turn();
		void end();

	private:
		std::shared_ptr<const Context> m_ui;
		std::shared_ptr<Text> m_round;
		std::shared_ptr<Text> m_player_turn;
		std::shared_ptr<Text> m_enemy_turn;
		std::shared_ptr<Text> m_end;
	};
}
