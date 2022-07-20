#include "combat_status.hpp"

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared, std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	CombatStatus::CombatStatus(std::shared_ptr<const Context> ui):
		m_ui {ui},
		m_round {std::make_shared<Text>(m_ui->empty_text())},
		m_player_turn {std::make_shared<Text>(
			m_ui->normal_text("Player turn"))},
		m_enemy_turn {std::make_shared<Text>(
			m_ui->normal_text("Enemy turn"))},
		m_end {std::make_shared<Text>(
			m_ui->normal_text("Combat ended"))}
	{
		children({m_round, m_player_turn, m_enemy_turn, m_end});
		auto spacing = m_ui->text_spacing;
		m_player_turn->place_below(*m_round, spacing);
		m_enemy_turn->place_on(*m_player_turn);
		update_size();
	}

	void
	CombatStatus::end()
	{
		m_round->hide();
		m_player_turn->hide();
		m_enemy_turn->hide();
		m_end->show();
	}

	void
	CombatStatus::enemy_turn()
	{
		m_player_turn->hide();
		m_enemy_turn->show();
	}

	void
	CombatStatus::player_turn()
	{
		m_enemy_turn->hide();
		m_player_turn->show();
	}

	void
	CombatStatus::round(int round)
	{
		m_end->hide();
		m_round->swap(
			m_ui->normal_text("Round " + std::to_string(round))
		);
	}
}
