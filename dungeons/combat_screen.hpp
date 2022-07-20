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

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace widget = ionpot::widget;

	class CombatScreen : public widget::Element {
	public:
		CombatScreen(
			std::shared_ptr<game::Log>,
			std::shared_ptr<const ui::Context>,
			game::Context&,
			const screen::ToCombat&);

		std::optional<screen::Output> on_click(const widget::Element&);

		void update();

	private:
		std::shared_ptr<game::Log> m_log;
		std::shared_ptr<game::Entity> m_player;
		std::shared_ptr<game::Entity> m_enemy;
		game::Combat m_combat;
		bool m_ended;
		std::shared_ptr<ui::EntityInfo> m_player_info;
		std::shared_ptr<ui::EntityInfo> m_enemy_info;
		std::shared_ptr<ui::Button> m_button;
		std::shared_ptr<ui::CombatStatus> m_status;
	};
}
