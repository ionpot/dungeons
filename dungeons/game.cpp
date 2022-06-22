#include "game.hpp"

#include "combat_screen.hpp"
#include "mouse.hpp"
#include "new_char_screen.hpp"
#include "screen.hpp"

#include <ui/context.hpp>

#include <game/context.hpp>
#include <game/log.hpp>

#include <ionpot/sdl/base.hpp>
#include <ionpot/sdl/events.hpp>

#include <memory> // std::shared_ptr
#include <utility> // std::move
#include <variant> // std::get_if

namespace dungeons {
	namespace sdl = ionpot::sdl;

	Game::Game(
			std::shared_ptr<game::Log> log,
			std::shared_ptr<const sdl::Base> base,
			std::shared_ptr<const sdl::Events> events,
			std::shared_ptr<const ui::Context> ui,
			std::shared_ptr<game::Context> game,
			Mouse&& mouse
	):
		m_log {log},
		m_base {base},
		m_events {events},
		m_ui {ui},
		m_game {game},
		m_mouse {std::move(mouse)}
	{}

	void
	Game::next(const screen::Output& output)
	{
		if (auto* input = std::get_if<screen::ToCombat>(&output)) {
			return loop(CombatScreen {m_log, *m_ui, *m_game, *input});
		}
	}

	void
	Game::loop()
	{
		loop(NewCharScreen {m_log, m_ui, m_game});
	}
}
