#include "combat_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/context.hpp>
#include <ui/string.hpp>
#include <ui/text.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/log.hpp>
#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	CombatScreen::CombatScreen(
			std::shared_ptr<util::Log> log,
			const ui::Context& ctx,
			const screen::ToCombat& input
	):
		m_log {log},
		m_text {
			ui::normal_text(ctx,
				ui::string::class_id(input.player) + " fights an enemy here.")
		},
		m_button {ui::unique_button(ctx, "Done")}
	{
		m_text.position({50});
		m_button.place_below(m_text, ctx.button.spacing);
		m_log->pair(ui::string::class_id(input.player), "enters combat.");
	}

	widget::Element*
	CombatScreen::find(util::Point point)
	{
		if (widget::contains(m_button, point))
			return &m_button;
		return nullptr;
	}

	std::optional<screen::Output>
	CombatScreen::on_click(const widget::Element& clicked)
	{
		if (m_button == clicked) {
			m_log->put("Combat ends.");
			return screen::Quit {};
		}
		return {};
	}

	void
	CombatScreen::render() const
	{
		widget::render(m_text);
		widget::render(m_button);
	}
}
