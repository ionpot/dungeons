#include "combat_status.hpp"

#include "context.hpp"
#include "text.hpp"

#include <game/combat.hpp>
#include <game/entity.hpp>
#include <game/string.hpp>

#include <ionpot/widget/rows.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	CombatStatus::CombatStatus(std::shared_ptr<const Context> ui):
		m_ui {ui},
		m_first {std::make_shared<Text>(m_ui->empty_text())},
		m_rows {std::make_shared<widget::Rows>(m_ui->text_spacing)},
		m_end {std::make_shared<Text>(m_ui->normal_text("Combat ended"))}
	{
		children({m_first, m_rows, m_end});
		hide_children();
	}

	void
	CombatStatus::attack(const game::Combat::Attack& atk, int round)
	{
		show_only(m_rows);
		m_rows->clear();

		namespace str = game::string;
		m_rows->add(m_ui->bold_text(str::round(round)));
		for (auto line : str::attack(atk))
			m_rows->add(m_ui->normal_text(line));
	}

	void
	CombatStatus::end()
	{ show_only(m_end); }

	void
	CombatStatus::goes_first(const game::Entity& e)
	{
		show_only(m_first);
		m_first->swap(
			m_ui->normal_text(e.name + " goes first."));
	}
}
