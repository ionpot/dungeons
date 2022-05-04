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
			std::shared_ptr<const ui::Context> ctx
	):
		m_log {log},
		m_ui {ctx},
		m_mouse {m_ui->mouse},
		m_left_click {m_ui->left_click},
		m_select {ui::class_select(*m_ui)},
		m_attributes {m_ui},
		m_done {ui::unique_button(*m_ui, "Done")},
		m_class_chosen {},
		m_rolled_attr {}
	{
		m_select.position({50});
		m_attributes.place_below(m_select, m_ui->button.spacing);
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
				return {};
			}
			if (!m_class_chosen) {
				return {};
			}
			if (auto rolled = m_attributes.on_click(*clicked)) {
				m_rolled_attr = rolled;
				m_done.place_below(m_attributes, m_ui->button.spacing);
				return {};
			}
			if (!m_rolled_attr) {
				return {};
			}
			if (clicked->on(m_done)) {
				m_log->pair("Chosen class:", ui::to_string(*m_class_chosen));
				m_log->pair("Attributes:", *m_rolled_attr);
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
			m_attributes.render();
		if (m_rolled_attr)
			m_done.render();
	}

	void
	NewCharScreen::update()
	{
		m_mouse->update();
		m_select.update();
		if (m_class_chosen)
			m_attributes.update();
		if (m_rolled_attr)
			m_done.update();
	}
}
