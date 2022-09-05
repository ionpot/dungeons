#include "new_char_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/exception.hpp>
#include <ui/weapon_select.hpp>

#include <game/context.hpp>
#include <game/entity.hpp>
#include <game/log.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>

namespace dungeons {
	namespace widget = ionpot::widget;

	NewCharScreen::NewCharScreen(
			std::shared_ptr<game::Log> log,
			std::shared_ptr<const ui::Context> ui,
			std::shared_ptr<game::Context> game
	):
		m_log {log},
		m_class {ui::class_select(*ui, game->class_templates)},
		m_attributes {std::make_shared<ui::NewAttributes>(ui, game)},
		m_stats {std::make_shared<ui::NewStats>(ui)},
		m_armor {std::make_shared<ui::ArmorSelect>(*ui, game->armors)},
		m_weapon {std::make_shared<ui::WeaponSelect>(*ui, game->weapons)},
		m_roll_attr {std::make_shared<ui::Button>(*ui, "Roll Attributes")},
		m_done {std::make_shared<ui::Button>(*ui, "Done")},
		m_entity {std::make_shared<game::Entity>("Player")}
	{
		m_entity->race = game->races.human;
		m_entity->base_armor = game->base_armor;

		children({m_roll_attr, m_done, m_class, m_attributes, m_stats, m_armor, m_weapon});

		m_class->position(ui->screen_margin);

		auto spacing = ui->section_spacing;

		m_roll_attr->place_below(*m_class, spacing);
		m_attributes->place_on(*m_roll_attr);
		m_stats->place_after(*m_attributes, spacing);
		m_armor->place_below(*m_attributes, spacing);
		m_weapon->place_below(*m_armor, spacing);
		m_done->place_after(*m_weapon, spacing);
		m_done->center_y_to(*m_weapon);

		show_only(m_class);
	}

	std::optional<screen::Output>
	NewCharScreen::on_click(const widget::Element& clicked)
	{
		if (*m_done == clicked) {
			m_log->entity(*m_entity);
			return screen::ToCombat {m_entity};
		}
		if (auto chosen = m_class->on_click(clicked)) {
			m_entity->klass.base_template = *chosen;
			if (m_attributes->hidden())
				m_roll_attr->show();
		}
		else if (*m_roll_attr == clicked) {
			m_roll_attr->hide();
			m_entity->base_attr = m_attributes->roll();
			m_attributes->show();
			m_stats->show();
			m_armor->show();
		}
		else if (m_attributes->is_clicked(clicked)) {
			m_entity->base_attr = m_attributes->roll();
		}
		else if (auto armor = m_armor->on_click(clicked)) {
			m_entity->armor = *armor;
			m_weapon->show();
		}
		else if (auto weapon = m_weapon->on_click(clicked)) {
			m_entity->weapon = *weapon;
			m_done->show();
		}
		refresh_stats();
		return {};
	}

	void
	NewCharScreen::refresh_stats()
	{
		if (m_stats->visible())
			m_stats->update(*m_entity);
	}
}
