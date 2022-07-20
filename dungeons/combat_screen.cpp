#include "combat_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/combat_status.hpp>
#include <ui/context.hpp>
#include <ui/entity_info.hpp>

#include <game/context.hpp>
#include <game/entity.hpp>
#include <game/log.hpp>
#include <game/string.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>

namespace dungeons {
	namespace widget = ionpot::widget;

	CombatScreen::CombatScreen(
			std::shared_ptr<game::Log> log,
			std::shared_ptr<const ui::Context> ui,
			game::Context& game,
			const screen::ToCombat& input
	):
		m_log {log},
		m_player {input.player},
		m_enemy {std::make_shared<game::Entity>(game.roll_orc())},
		m_combat {m_player, m_enemy},
		m_ended {false},
		m_player_info {std::make_shared<ui::EntityInfo>(*ui, *m_player)},
		m_enemy_info {std::make_shared<ui::EntityInfo>(*ui, *m_enemy)},
		m_button {std::make_shared<ui::Button>(*ui, "Next")},
		m_status {std::make_shared<ui::CombatStatus>(ui)}
	{
		children({m_button, m_player_info, m_enemy_info, m_status});

		auto spacing = ui->section_spacing;
		m_player_info->position(ui->screen_margin);
		m_enemy_info->place_after(*m_player_info, spacing);
		m_button->place_below(*m_player_info, spacing);
		m_status->place_below(*m_button, spacing);

		m_log->put("Enemy");
		m_log->entity(*m_enemy);

		m_log->put("Combat begins");
		update();
	}

	std::optional<screen::Output>
	CombatScreen::on_click(const widget::Element& clicked)
	{
		if (*m_button == clicked) {
			if (m_ended)
				return screen::Quit {};
			if (m_combat.ended())
				m_ended = true;
			else
				m_combat.next_turn();
			update();
		}
		return {};
	}

	void
	CombatScreen::update()
	{
		if (m_ended) {
			m_status->end();
			m_log->put("Combat ends");
			return;
		}
		if (m_combat.new_round()) {
			auto round = m_combat.current_round();
			m_status->round(round);
			m_log->pair("Round", round);
		}
		auto entity = m_combat.current_turn();
		if (entity == m_player) {
			m_status->player_turn();
			m_log->put("Player turn");
			return;
		}
		if (entity == m_enemy) {
			m_status->enemy_turn();
			m_log->put("Enemy turn");
			return;
		}
	}
}
