#include "new_attributes.hpp"

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <game/context.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>

#define LABELS m_str, m_agi, m_int

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	// Labels
	NewAttributes::Labels::Labels(std::shared_ptr<const Context> ui):
		m_str {std::make_shared<LabelValue>(ui, "Strength")},
		m_agi {std::make_shared<LabelValue>(ui, "Agility")},
		m_int {std::make_shared<LabelValue>(ui, "Intellect")}
	{
		children({LABELS});
		stack_labels(*ui, {LABELS});
		update_size();
	}

	void
	NewAttributes::Labels::update(const Value& value)
	{
		m_str->value(value.strength);
		m_agi->value(value.agility);
		m_int->value(value.intellect);
		update_size();
	}

	// NewAttributes
	NewAttributes::NewAttributes(
			std::shared_ptr<const Context> ui,
			std::shared_ptr<game::Context> game):
		m_game {game},
		m_roll {std::make_shared<Button>(*ui, "Roll Attributes")},
		m_reroll {std::make_shared<Button>(*ui, "Roll Again")},
		m_labels {std::make_shared<Labels>(ui)}
	{
		children({m_roll, m_reroll, m_labels});
		m_reroll->place_below(*m_labels, ui->text_spacing);
		m_reroll->hide();
		m_labels->hide();
		update_size();
	}

	std::optional<NewAttributes::Value>
	NewAttributes::on_click(const widget::Element& clicked)
	{
		if (*m_roll == clicked) {
			m_roll->hide();
			m_reroll->show();
			m_labels->show();
			return roll();
		}
		if (*m_reroll == clicked)
			return roll();
		return {};
	}

	NewAttributes::Value
	NewAttributes::roll()
	{
		auto attr = m_game->roll_human_attrs();
		m_labels->update(attr);
		update_size();
		return attr;
	}
}
