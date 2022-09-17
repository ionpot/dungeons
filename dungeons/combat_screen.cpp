#include "combat_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/combat_status.hpp>
#include <ui/context.hpp>
#include <ui/entity_info.hpp>
#include <ui/level_up.hpp>

#include <game/context.hpp>
#include <game/entity.hpp>
#include <game/level_up.hpp>
#include <game/log.hpp>
#include <game/string.hpp>

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/swap.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>

namespace dungeons {
	namespace widget = ionpot::widget;

	CombatScreen::CombatScreen(
			std::shared_ptr<game::Log> log,
			std::shared_ptr<const ui::Context> ui,
			std::shared_ptr<game::Context> game,
			const screen::ToCombat& input
	):
		m_log {log},
		m_ui {ui},
		m_game {game},
		m_player {input.player},
		m_enemy {
			std::make_shared<game::Entity>(m_player->roll_enemy(*m_game))
		},
		m_combat {m_player, m_enemy},
		m_player_info {std::make_shared<ui::EntityInfo>(*m_ui, *m_player)},
		m_enemy_info {std::make_shared<ui::EntityInfo>(*m_ui, *m_enemy)},
		m_button {std::make_shared<ui::Button>(*m_ui, "Next")},
		m_status {std::make_shared<ui::CombatStatus>(m_ui)},
		m_level_up {std::make_shared<ui::LevelUp>(m_ui)},
		m_level_up_done {false}
	{
		children({m_button, m_player_info, m_enemy_info, m_status, m_level_up});

		auto spacing = m_ui->section_spacing;
		m_player_info->position(m_ui->screen_margin);
		m_enemy_info->place_after(*m_player_info, spacing);
		m_button->place_below(*m_player_info, spacing);
		m_status->place_below(*m_button, spacing);

		m_level_up->hide();

		m_log->endl();
		m_log->entity(*m_enemy);

		m_status->goes_first(*m_combat.turn_of());
		m_log->endl();
		m_log->put("Combat begins");
	}

	void
	CombatScreen::do_attack()
	{
		auto round = m_combat.round();
		if (m_combat.new_round()) {
			m_log->endl();
			m_log->pair("Round", round);
		}
		auto atk = m_combat.attack(*m_game->dice);
		m_status->attack(atk, round);

		m_log->endl();
		m_log->lines(game::string::attack(atk));

		if (atk.damage) {
			if (atk.defender == m_player)
				refresh_info(*m_player_info, *m_player);
			else
				refresh_info(*m_enemy_info, *m_enemy);
		}

		m_combat.next_turn();
	}

	void
	CombatScreen::do_level_up()
	{
		const auto& lvup = m_level_up->state();
		if (lvup.done()) {
			m_player->level_up(lvup);
			refresh_info(*m_player_info, *m_player);
			m_level_up->hide();
			m_status->hide();
			m_button->show();
			m_level_up_done = true;
			m_log->endl();
			m_log->write(m_player->name);
			m_log->put(game::string::class_level(*m_player));
			m_log->put(game::string::level_up(lvup));
		}
		else {
			level_up_info(lvup);
		}
	}

	std::optional<screen::Output>
	CombatScreen::do_end()
	{
		m_log->endl();
		m_log->put("Combat ends");

		if (m_player->dead())
			return screen::Quit {};

		m_player->add_xp(*m_game);

		if (auto lvup = m_player->try_level_up(*m_game)) {
			m_button->hide();
			m_status->level_up(*m_player);
			m_level_up->state(*lvup);
			m_level_up->place_below(*m_status, m_ui->section_spacing);
			m_level_up->show();
			level_up_info(m_level_up->state());
			return {};
		}

		return next_combat();
	}

	void
	CombatScreen::level_up_info(const game::LevelUp& lvup)
	{
		auto p = *m_player;
		p.level_up(lvup);
		refresh_info(*m_player_info, p);
	}

	screen::Output
	CombatScreen::next_combat() const
	{
		m_player->restore_hp();
		return screen::ToCombat {m_player};
	}

	std::optional<screen::Output>
	CombatScreen::on_click(const widget::Element& clicked)
	{
		if (m_level_up->on_click(clicked)) {
			do_level_up();
			return {};
		}
		if (*m_button == clicked) {
			if (m_level_up_done)
				return next_combat();
			if (m_combat.ended())
				return do_end();
			do_attack();
		}
		return {};
	}

	void
	CombatScreen::refresh_info(
			ui::EntityInfo& info,
			const game::Entity& entity)
	{ widget::swap(info, ui::EntityInfo {*m_ui, entity}); }
}
