#include "new_attributes.hpp"

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"
#include "text.hpp"

#include <ionpot/widget/box.hpp>
#include <ionpot/widget/label_value.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/vector.hpp>

#include <memory> // std::shared_ptr
#include <optional>
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	NewAttributes::NewAttributes(std::shared_ptr<const Context> ctx):
		widget::Box {},
		m_ui {ctx},
		m_roll {unique_button(*m_ui, "Roll attributes")},
		m_reroll {unique_button(*m_ui, "Reroll")},
		m_value {},
		m_str {normal_text(*m_ui, "Strength")},
		m_agi {normal_text(*m_ui, "Agility")},
		m_int {normal_text(*m_ui, "Intelligence")}
	{
		std::vector<LabelValue*> labels {
			&m_str, &m_agi, &m_int
		};
		auto spacing = m_ui->button.spacing;
		widget::align_labels(labels, spacing);
		m_agi.place_below(m_str, spacing);
		m_int.place_below(m_agi, spacing);
		m_reroll.place_below(m_int, spacing);
		update_size();
	}

	std::optional<NewAttributes::Value>
	NewAttributes::on_click(
			const widget::Click& clicked,
			util::Point offset)
	{
		auto pos = position() + offset;
		if (m_value) {
			if (clicked.on(m_reroll, pos)) {
				update_value();
				return m_value;
			}
		}
		else {
			if (clicked.on(m_roll, pos)) {
				update_value();
				return m_value;
			}
		}
		return {};
	}

	void
	NewAttributes::render(util::Point offset) const
	{
		auto pos = position() + offset;
		if (m_value) {
			m_str.render(pos);
			m_agi.render(pos);
			m_int.render(pos);
			m_reroll.render(pos);
		}
		else {
			m_roll.render(pos);
		}
	}

	void
	NewAttributes::update(util::Point offset)
	{
		auto pos = position() + offset;
		if (m_value)
			m_reroll.update(pos);
		else
			m_roll.update(pos);
	}

	void
	NewAttributes::update_size()
	{
		std::vector<widget::Box> ls;
		if (m_value) {
			ls.push_back(m_str);
			ls.push_back(m_agi);
			ls.push_back(m_int);
			ls.push_back(m_reroll);
		}
		else {
			ls.push_back(m_roll);
		}
		size(widget::sum_sizes(ls));
	}

	void
	NewAttributes::update_value()
	{
		if (m_value)
			m_value = *m_value + 1;
		else
			m_value = 0;
		m_str.value(bold_text(*m_ui, *m_value));
		m_agi.value(bold_text(*m_ui, *m_value));
		m_int.value(bold_text(*m_ui, *m_value));
		update_size();
	}
}
