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
		m_enemy {std::make_shared<game::Entity>(game.roll_orc("Enemy"))},
		m_combat {m_player, m_enemy},
		m_begun {false},
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

		m_log->entity(*m_enemy);
		m_log->endl();
		m_log->put("Combat begins");

		m_status->goes_first(*m_combat.turn_of());
	}

	std::optional<screen::Output>
	CombatScreen::on_click(const widget::Element& clicked)
	{
		if (*m_button == clicked) {
			if (m_combat.ended()) {
				m_status->end();
				m_log->endl();
				m_log->put("Combat ends");
				return screen::Quit {};
			}
			if (m_begun)
				m_combat.next_turn();
			else
				m_begun = true;
			update();
		}
		return {};
	}

	void
	CombatScreen::update()
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
}
