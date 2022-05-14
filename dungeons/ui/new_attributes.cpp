#include "new_attributes.hpp"

#include "context.hpp"
#include "label_value.hpp"
#include "text.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/label_value.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/vector.hpp>

#include <memory> // std::shared_ptr
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	NewAttributes::NewAttributes(std::shared_ptr<const Context> ctx):
		widget::Element {},
		m_ui {ctx},
		m_value {0},
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
		update_size();
	}

	void
	NewAttributes::render(util::Point offset) const
	{
		widget::Element::render(m_str, offset);
		widget::Element::render(m_agi, offset);
		widget::Element::render(m_int, offset);
	}

	NewAttributes::Value
	NewAttributes::roll()
	{
		m_value += 1;
		update_text();
		return m_value;
	}

	void
	NewAttributes::update_size()
	{
		std::vector<widget::Element> ls {
			m_str, m_agi, m_int
		};
		size(widget::sum_sizes(ls));
	}

	void
	NewAttributes::update_text()
	{
		m_str.value(bold_text(*m_ui, m_value));
		m_agi.value(bold_text(*m_ui, m_value));
		m_int.value(bold_text(*m_ui, m_value));
		update_size();
	}
}
