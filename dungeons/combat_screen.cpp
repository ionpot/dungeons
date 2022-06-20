#include "combat_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/context.hpp>
#include <ui/entity_info.hpp>

#include <game/log.hpp>
#include <game/string.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>

namespace dungeons {
	namespace widget = ionpot::widget;

	CombatScreen::CombatScreen(
			std::shared_ptr<game::Log> log,
			const ui::Context& ui,
			const screen::ToCombat& input
	):
		m_log {log},
		m_player_info {std::make_shared<ui::EntityInfo>(ui, *input.player)},
		m_button {std::make_shared<ui::Button>(ui, "Done")}
	{
		elements({m_button});
		groups({m_player_info});
		m_player_info->position(ui.screen_margin);
		m_button->place_below(*m_player_info, ui.section_spacing);
		m_log->put("Combat begins.");
	}

	std::optional<screen::Output>
	CombatScreen::on_click(const widget::Element& clicked)
	{
		if (*m_button == clicked) {
			m_log->put("Combat ends.");
			return screen::Quit {};
		}
		return {};
	}
}
