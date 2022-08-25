#include "combat_status.hpp"

#include "context.hpp"

#include <game/combat.hpp>
#include <game/entity.hpp>
#include <game/string.hpp>

#include <ionpot/widget/rows.hpp>

#include <memory> // std::make_shared, std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	CombatStatus::CombatStatus(std::shared_ptr<const Context> ui):
		m_ui {ui},
		m_rows {std::make_shared<widget::Rows>(m_ui->text_spacing)}
	{
		children({m_rows});
	}

	void
	CombatStatus::attack(const game::Combat::Attack& atk, int round)
	{
		m_rows->clear();

		namespace str = game::string;
		m_rows->add(m_ui->bold_text(str::round(round)));
		for (auto line : str::attack(atk))
			m_rows->add(m_ui->normal_text(line));
		update_size();
	}

	void
	CombatStatus::goes_first(const game::Entity& e)
	{
		m_rows->clear();
		m_rows->add(m_ui->normal_text(e.name + " goes first."));
		update_size();
	}

	void
	CombatStatus::level_up(const game::Entity& e)
	{
		m_rows->clear();
		m_rows->add(m_ui->normal_text(e.name + " level up."));
		update_size();
	}
}
