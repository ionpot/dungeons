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

	NewAttributes::NewAttributes(
			std::shared_ptr<const Context> ui,
			std::shared_ptr<game::Context> game):
		widget::Element {},
		m_ui {ui},
		m_game {game},
		m_roll {unique_button(*m_ui, "Roll Attributes")},
		m_reroll {unique_button(*m_ui, "Roll Again")},
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

		m_str.hide();
		m_agi.hide();
		m_int.hide();
		m_reroll.hide();

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
			m_str.show();
			m_agi.show();
			m_int.show();
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
		widget::Element::render(m_str, offset);
		widget::Element::render(m_agi, offset);
		widget::Element::render(m_int, offset);
	}

	NewAttributes::Value
	NewAttributes::roll()
	{
		Value attr {m_game->roll_attributes()};
		update_text(attr);
		return attr;
	}

	void
	NewAttributes::update_size()
	{
		std::vector<widget::Element> ls {
			m_roll, m_reroll, m_str, m_agi, m_int
		};
		size(widget::sum_sizes(ls));
	}

	void
	NewAttributes::update_text(const Value& value)
	{
		m_str.value(bold_text(*m_ui, value.strength()));
		m_agi.value(bold_text(*m_ui, value.agility()));
		m_int.value(bold_text(*m_ui, value.intelligence()));
		update_size();
	}
}
