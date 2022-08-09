#pragma once

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/combat_status.hpp>
#include <ui/context.hpp>
#include <ui/entity_info.hpp>

#include <game/combat.hpp>
#include <game/context.hpp>
#include <game/entity.hpp>
#include <game/log.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class CombatScreen : public widget::Element {
	public:
		CombatScreen(
			std::shared_ptr<game::Log>,
			std::shared_ptr<const ui::Context>,
			game::Context&,
			const screen::ToCombat&);

		std::optional<screen::Output> on_click(const widget::Element&);

	private:
		enum class State {combat, end, next_screen};

		std::shared_ptr<game::Log> m_log;
		std::shared_ptr<util::dice::Engine> m_dice;
		std::shared_ptr<game::Entity> m_player;
		std::shared_ptr<game::Entity> m_enemy;
		game::Combat m_combat;
		State m_state;
		std::shared_ptr<ui::EntityInfo> m_player_info;
		std::shared_ptr<ui::EntityInfo> m_enemy_info;
		std::shared_ptr<ui::Button> m_button;
		std::shared_ptr<ui::CombatStatus> m_status;

		void do_attack();
		void do_first();
		void do_level_up();
	};
}
