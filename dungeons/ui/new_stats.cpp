#include "new_stats.hpp"

#include "context.hpp"
#include "label_value.hpp"
#include "text.hpp"

#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/sum_sizes.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	NewStats::NewStats(std::shared_ptr<const Context> ui):
		widget::Element {},
		m_ui {ui},
		m_hp {normal_text(*m_ui, "Total Hp")},
		m_armor {normal_text(*m_ui, "Armor")},
		m_dodge {normal_text(*m_ui, "Dodge")},
		m_initiative {normal_text(*m_ui, "Initiative")},
		m_will {normal_text(*m_ui, "Spell Resist")}
	{
		std::vector<LabelValue*> labels {
			&m_hp, &m_armor, &m_dodge, &m_initiative, &m_will
		};
		align_labels(*m_ui, labels);
		stack_text(*m_ui, labels);
		update_size();
	}

	void
	NewStats::render(util::Point offset) const
	{
		widget::Element::render(m_hp, offset);
		widget::Element::render(m_armor, offset);
		widget::Element::render(m_dodge, offset);
		widget::Element::render(m_initiative, offset);
		widget::Element::render(m_will, offset);
	}

	void
	NewStats::update(const game::Entity& entity)
	{
		m_hp.value(bold_text(*m_ui, entity.total_hp()));
		m_armor.value(bold_text(*m_ui, entity.armor()));
		m_dodge.value(bold_text(*m_ui, entity.dodge_chance().to_str()));
		m_initiative.value(bold_text(*m_ui, entity.initiative()));
		m_will.value(bold_text(*m_ui, entity.resist_chance().to_str()));
		update_size();
	}

	void
	NewStats::update_size()
	{
		size(widget::sum_sizes({
			m_hp, m_armor, m_dodge, m_initiative, m_will
		}));
	}
}
