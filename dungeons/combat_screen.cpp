#include "combat_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/context.hpp>
#include <ui/string.hpp>
#include <ui/text.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/log.hpp>
#include <ionpot/util/point.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	CombatScreen::CombatScreen(
			std::shared_ptr<util::Log> log,
			const ui::Context& ui,
			const screen::ToCombat& input
	):
		m_log {log},
		m_text {std::make_shared<ui::Text>(
			ui::normal_text(ui,
				ui::string::class_id(input.player) + " fights an enemy here.")
		)},
		m_button {std::make_shared<ui::Button>(ui, "Done")}
	{
		elements({m_text, m_button});
		m_text->position(ui.screen_margin);
		m_button->place_below(*m_text, ui.button.spacing);
		m_log->pair(ui::string::class_id(input.player), "enters combat.");
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
