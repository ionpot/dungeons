#include "new_attributes.hpp"

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"
#include "text.hpp"

#include <game/context.hpp>

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/label_value.hpp>
#include <ionpot/widget/sum_sizes.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/vector.hpp>

#include <memory> // std::shared_ptr
#include <optional>
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	// Labels
	NewAttributes::Labels::Labels(std::shared_ptr<const Context> ui):
		m_ui {ui},
		m_str {normal_text(*m_ui, "Strength")},
		m_agi {normal_text(*m_ui, "Agility")},
		m_int {normal_text(*m_ui, "Intellect")}
	{
		std::vector<LabelValue*> labels {&m_str, &m_agi, &m_int};
		align_labels(*m_ui, labels);
		stack_text(*m_ui, labels);
		update_size();
	}

	void
	NewAttributes::Labels::render(util::Point offset) const
	{
		widget::Element::render(m_str, offset);
		widget::Element::render(m_agi, offset);
		widget::Element::render(m_int, offset);
	}

	void
	NewAttributes::Labels::update(const Value& value)
	{
		m_str.value(bold_text(*m_ui, value.strength()));
		m_agi.value(bold_text(*m_ui, value.agility()));
		m_int.value(bold_text(*m_ui, value.intellect()));
		update_size();
	}

	void
	NewAttributes::Labels::update_size()
	{
		std::vector<widget::Element> ls {
			m_str, m_agi, m_int
		};
		size(widget::sum_sizes(ls));
	}

	// NewAttributes
	NewAttributes::NewAttributes(
			std::shared_ptr<const Context> ui,
			std::shared_ptr<game::Context> game):
		m_game {game},
		m_roll {unique_button(*ui, "Roll Attributes")},
		m_reroll {unique_button(*ui, "Roll Again")},
		m_labels {ui}
	{
		m_reroll.place_below(m_labels, ui->text_spacing);
		m_reroll.hide();
		m_labels.hide();
		update_size();
	}

	widget::Element*
	NewAttributes::find(util::Point point, util::Point offset)
	{
		if (contains(m_roll, point, offset))
			return &m_roll;
		if (contains(m_reroll, point, offset))
			return &m_reroll;
		return nullptr;
	}

	std::optional<NewAttributes::Value>
	NewAttributes::on_click(const widget::Element& clicked)
	{
		if (m_roll == clicked) {
			m_roll.hide();
			m_reroll.show();
			m_labels.show();
			return roll();
		}
		if (m_reroll == clicked)
			return roll();
		return {};
	}

	void
	NewAttributes::render(util::Point offset) const
	{
		widget::Element::render(m_roll, offset);
		widget::Element::render(m_reroll, offset);
		widget::Element::render(m_labels, offset);
	}

	NewAttributes::Value
	NewAttributes::roll()
	{
		Value attr {*m_game};
		m_labels.update(attr);
		update_size();
		return attr;
	}

	void
	NewAttributes::update_size()
	{
		std::vector<widget::Element> ls {
			m_roll, m_reroll, m_labels
		};
		size(widget::sum_sizes(ls));
	}
}
