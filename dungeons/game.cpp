#include "game.hpp"

#include "combat_screen.hpp"
#include "new_char_screen.hpp"
#include "screen.hpp"

#include <ui/context.hpp>

#include <ionpot/sdl/base.hpp>
#include <ionpot/sdl/events.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::shared_ptr
#include <variant> // std::get_if

namespace dungeons {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;

	Game::Game(
			std::shared_ptr<util::Log> log,
			std::shared_ptr<const sdl::Base> base,
			std::shared_ptr<const sdl::Events> events,
			std::shared_ptr<const ui::Context> ui
	):
		m_log {log},
		m_base {base},
		m_events {events},
		m_ui {ui}
	{}

	void
	Game::next(const screen::Output& output) const
	{
		m_ui->reset_cursor();
		if (auto* input = std::get_if<screen::ToCombat>(&output)) {
			return loop(CombatScreen {m_log, *m_ui, *input});
		}
	}

	void
	Game::loop() const
	{
		loop(NewCharScreen {m_log, *m_ui});
	}
}
