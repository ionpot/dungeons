#include "new_char_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/to_string.hpp>

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
			std::shared_ptr<const ui::Context> ctx
	):
		m_log {log},
		m_ui {ctx},
		m_select {ui::class_select(*m_ui)},
		m_attributes {m_ui},
		m_roll_attr {ui::unique_button(*m_ui, "Roll Attributes")},
		m_reroll_attr {ui::unique_button(*m_ui, "Roll Again")},
		m_done {ui::unique_button(*m_ui, "Done")},
		m_class_chosen {},
		m_rolled_attr {}
	{
		m_select.position({50});

		auto spacing = m_ui->button.spacing;
		m_roll_attr.place_below(m_select, spacing);
		m_attributes.place_below(m_select, spacing);
		m_reroll_attr.place_below(m_attributes, spacing);
		m_done.place_below(m_reroll_attr, spacing);

		m_roll_attr.hide();
		m_reroll_attr.hide();
		m_attributes.hide();
		m_done.hide();
	}

	widget::Element*
	NewCharScreen::find(util::Point point)
	{
		if (auto* found = widget::find(m_select, point))
			return found;
		if (widget::contains(m_roll_attr, point))
			return &m_roll_attr;
		if (widget::contains(m_reroll_attr, point))
			return &m_reroll_attr;
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
				m_roll_attr.show();
			return {};
		}
		if (m_roll_attr == clicked) {
			m_rolled_attr = m_attributes.roll();
			m_roll_attr.hide();
			m_attributes.show();
			m_reroll_attr.show();
			m_done.show();
			return {};
		}
		if (m_reroll_attr == clicked) {
			m_rolled_attr = m_attributes.roll();
			return {};
		}
		if (m_done == clicked) {
			m_log->pair("Chosen class:", ui::to_string(*m_class_chosen));
			m_log->pair("Attributes:", *m_rolled_attr);
			return screen::ToCombat {*m_class_chosen};
		}
		return {};
	}

	void
	NewCharScreen::render() const
	{
		widget::render(m_select);
		widget::render(m_roll_attr);
		widget::render(m_reroll_attr);
		widget::render(m_attributes);
		widget::render(m_done);
	}
}
