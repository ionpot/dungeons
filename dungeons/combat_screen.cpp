#include "combat_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/context.hpp>
#include <ui/text.hpp>
#include <ui/to_string.hpp>

#include <ionpot/sdl/event.hpp>
#include <ionpot/sdl/mouse.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;

	CombatScreen::CombatScreen(
			std::shared_ptr<util::Log> log,
			const ui::Context& ctx,
			const screen::ToCombat& input
	):
		m_log {log},
		m_mouse {ctx.mouse},
		m_left_click {ctx.left_click},
		m_text {
			ui::normal_text(ctx,
				ui::to_string(input.player) + " fights an enemy here.")
		},
		m_button {ui::unique_button(ctx, "Done")}
	{
		m_text.position({50});
		m_button.place_below(m_text, ctx.button.spacing);
		m_log->pair(ui::to_string(input.player), "enters combat.");
	}

	std::optional<screen::Output>
	CombatScreen::handle(const sdl::Event& event)
	{
		if (auto key = event.key_up()) {
			return screen::Quit {};
		}
		if (auto clicked = m_left_click->check(event)) {
			if (clicked->on(m_button)) {
				m_log->put("Combat ends.");
				return screen::Quit {};
			}
		}
		return {};
	}

	void
	CombatScreen::render() const
	{
		m_text.render();
		m_button.render();
	}

	void
	CombatScreen::update()
	{
		m_mouse->update();
		m_button.update();
	}
}
