#include "new_char_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/to_string.hpp>

#include <ionpot/sdl/event.hpp>
#include <ionpot/sdl/mouse.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;

	NewCharScreen::NewCharScreen(
			std::shared_ptr<util::Log> log,
			const ui::Context& ctx
	):
		m_log {log},
		m_mouse {ctx.mouse},
		m_left_click {ctx.left_click},
		m_select {ui::class_select(ctx)},
		m_done {ui::unique_button(ctx, "Done")},
		m_class_chosen {}
	{
		m_select.position({50});
		m_done.place_below(m_select, ctx.button.spacing);
	}

	std::optional<screen::Output>
	NewCharScreen::handle(const sdl::Event& event)
	{
		if (auto key = event.key_up()) {
			return screen::Quit {};
		}
		if (auto clicked = m_left_click->check(event)) {
			if (auto chosen = m_select.on_click(*clicked)) {
				m_class_chosen = chosen;
			}
			else if (m_class_chosen && clicked->on(m_done)) {
				m_log->pair("Chosen class:", ui::to_string(*m_class_chosen));
				return screen::ToCombat {*m_class_chosen};
			}
		}
		return {};
	}

	void
	NewCharScreen::render() const
	{
		m_select.render();
		if (m_class_chosen)
			m_done.render();
	}

	void
	NewCharScreen::update()
	{
		m_mouse->update();
		m_select.update();
		if (m_class_chosen)
			m_done.update();
	}
}
