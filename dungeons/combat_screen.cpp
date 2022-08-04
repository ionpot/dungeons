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
		m_dice {game.dice},
		m_player {input.player},
		m_enemy {input.enemy
			? input.enemy
			: std::make_shared<game::Entity>(game.roll_orc("Enemy"))
		},
		m_combat {m_player, m_enemy},
		m_state {State::combat},
		m_player_info {std::make_shared<ui::EntityInfo>(ui, m_player)},
		m_enemy_info {std::make_shared<ui::EntityInfo>(ui, m_enemy)},
		m_button {std::make_shared<ui::Button>(*ui, "Next")},
		m_status {std::make_shared<ui::CombatStatus>(ui)}
	{
		children({m_button, m_player_info, m_enemy_info, m_status});

		auto spacing = ui->section_spacing;
		m_player_info->position(ui->screen_margin);
		m_enemy_info->place_after(*m_player_info, spacing);
		m_button->place_below(*m_player_info, spacing);
		m_status->place_below(*m_button, spacing);

		m_log->endl();
		m_log->entity(*m_enemy);

		do_first();
	}

	void
	CombatScreen::do_attack()
	{
		auto round = m_combat.round();
		if (m_combat.new_round()) {
			m_log->endl();
			m_log->pair("Round", round);
		}
		auto atk = m_combat.attack(*m_dice);
		m_status->attack(atk, round);

		m_log->endl();
		m_log->lines(game::string::attack(atk));

		m_player_info->update();
		m_enemy_info->update();
	}

	void
	CombatScreen::do_end()
	{
		auto& winner = m_player->alive() ? *m_player : *m_enemy;
		m_status->end(winner);
		m_log->endl();
		m_log->put("Combat ends");
		winner.level_up();
		winner.restore_hp();
		if (m_player->dead()) {
			m_player->reset_level();
			m_player->restore_hp();
		}
		m_log->endl();
		m_log->write(winner.name);
		m_log->write(game::string::class_level(winner), ", ");
		m_log->pair("Hp", winner.total_hp());
	}

	void
	CombatScreen::do_first()
	{
		m_status->goes_first(*m_combat.turn_of());
		m_log->endl();
		m_log->put("Combat begins");
	}

	std::optional<screen::Output>
	CombatScreen::on_click(const widget::Element& clicked)
	{
		if (*m_button != clicked)
			return {};
		if (m_state == State::next_screen) {
			return screen::ToCombat {
				m_player,
				m_enemy->alive() ? m_enemy : nullptr
			};
		}
		if (m_state == State::end) {
			do_end();
			m_state = State::next_screen;
		}
		else if (m_state == State::combat) {
			do_attack();
			if (m_combat.ended())
				m_state = State::end;
			else
				m_combat.next_turn();
		}
		return {};
	}
}
