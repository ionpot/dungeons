#include "new_char_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/to_string.hpp>

#include <game/context.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/log.hpp>
#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	NewCharScreen::NewCharScreen(
			std::shared_ptr<util::Log> log,
			std::shared_ptr<const ui::Context> ui,
			std::shared_ptr<game::Context> game
	):
		m_log {log},
		m_spacing {ui->button.spacing},
		m_select {ui::class_select(*ui)},
		m_attributes {ui, game},
		m_done {ui::unique_button(*ui, "Done")},
		m_class_chosen {},
		m_rolled_attr {}
	{
		m_select.position({50});

		m_attributes.place_below(m_select, m_spacing);

		m_attributes.hide();
		m_done.hide();
	}

	widget::Element*
	NewCharScreen::find(util::Point point)
	{
		if (auto* found = widget::find(m_select, point))
			return found;
		if (auto* found = widget::find(m_attributes, point))
			return found;
		if (widget::contains(m_done, point))
			return &m_done;
		return nullptr;
	}

	std::optional<screen::Output>
	NewCharScreen::on_click(const widget::Element& clicked)
	{
		if (auto chosen = m_select.on_click(clicked)) {
			m_class_chosen = chosen;
			if (m_attributes.hidden())
				m_attributes.show();
			return {};
		}
		if (auto rolled = m_attributes.on_click(clicked)) {
			if (!m_rolled_attr) {
				m_done.place_below(m_attributes, m_spacing);
				m_done.show();
			}
			m_rolled_attr = rolled;
			return {};
		}
		if (m_done == clicked) {
			m_log->pair("Chosen class:", ui::to_string(*m_class_chosen));
			m_log->pair("Strength:", m_rolled_attr->strength());
			m_log->pair("Agility:", m_rolled_attr->agility());
			m_log->pair("Intelligence:", m_rolled_attr->intelligence());
			return screen::ToCombat {*m_class_chosen};
		}
		return {};
	}

	void
	NewCharScreen::render() const
	{
		widget::render(m_select);
		widget::render(m_attributes);
		widget::render(m_done);
	}
}
