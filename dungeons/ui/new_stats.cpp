#include "new_stats.hpp"

#include "context.hpp"
#include "label_value.hpp"

#include <game/entity.hpp>

#include <memory> // std::make_shared, std::shared_ptr

#define LABELS m_hp, m_armor, m_dodge, m_initiative, m_will, m_weapon

namespace dungeons::ui {
	NewStats::NewStats(std::shared_ptr<const Context> ui):
		m_hp {std::make_shared<LabelValue>(ui, "Total Hp")},
		m_armor {std::make_shared<LabelValue>(ui, "Armor")},
		m_dodge {std::make_shared<LabelValue>(ui, "Dodge")},
		m_initiative {std::make_shared<LabelValue>(ui, "Initiative")},
		m_will {std::make_shared<LabelValue>(ui, "Spell Resist")},
		m_weapon {std::make_shared<LabelValue>(ui, "Weapon Damage")}
	{
		elements({LABELS});
		stack_labels(*ui, {LABELS});
		update_size();
	}

	void
	NewStats::update(const game::Entity& entity)
	{
		m_hp->value(entity.total_hp());
		m_armor->value(entity.total_armor());
		m_dodge->value(entity.dodge_chance());
		m_initiative->value(entity.initiative());
		m_will->value(entity.resist_chance());
		m_weapon->value(entity.weapon_damage());
		update_size();
	}
}
