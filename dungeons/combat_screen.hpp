#pragma once

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/combat_status.hpp>
#include <ui/context.hpp>
#include <ui/entity_info.hpp>
#include <ui/level_up.hpp>

#include <game/combat.hpp>
#include <game/context.hpp>
#include <game/entity.hpp>
#include <game/log.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace widget = ionpot::widget;

	class CombatScreen : public widget::Element {
	public:
		CombatScreen(
			std::shared_ptr<game::Log>,
			std::shared_ptr<const ui::Context>,
			std::shared_ptr<game::Context>,
			const screen::ToCombat&);

		std::optional<screen::Output> on_click(const widget::Element&);

	private:
		std::shared_ptr<game::Log> m_log;
		std::shared_ptr<const ui::Context> m_ui;
		std::shared_ptr<game::Context> m_game;
		std::shared_ptr<game::Entity> m_player;
		std::shared_ptr<game::Entity> m_enemy;
		game::Combat m_combat;
		std::shared_ptr<ui::EntityInfo> m_player_info;
		std::shared_ptr<ui::EntityInfo> m_enemy_info;
		std::shared_ptr<ui::Button> m_button;
		std::shared_ptr<ui::CombatStatus> m_status;
		std::shared_ptr<ui::LevelUp> m_level_up;
		bool m_level_up_done;

		void do_attack();
		std::optional<screen::Output> do_end();
		void do_level_up();

		void level_up_info(const game::Entity::LevelUp&);

		void refresh_info(ui::EntityInfo&, const game::Entity&);
	};
}
