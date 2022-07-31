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
		m_chosen {game->races.human, game->base_armor}
	{
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

		m_roll_attr->hide();
		m_attributes->hide();
		m_stats->hide();
		m_armor->hide();
		m_weapon->hide();
		m_done->hide();
	}

	std::optional<screen::Output>
	NewCharScreen::on_click(const widget::Element& clicked)
	{
		if (auto chosen = m_class->on_click(clicked)) {
			m_chosen.class_template = *chosen;
			refresh_stats();
			m_roll_attr->show();
			return {};
		}
		if (*m_roll_attr == clicked) {
			m_roll_attr->hide();
			m_chosen.base_attr = m_attributes->roll();
			refresh_stats();
			m_attributes->show();
			m_stats->show();
			m_armor->show();
			return {};
		}
		if (m_attributes->is_clicked(clicked)) {
			m_chosen.base_attr = m_attributes->roll();
			refresh_stats();
			return {};
		}
		if (auto armor = m_armor->on_click(clicked)) {
			m_chosen.armor = *armor;
			refresh_stats();
			m_weapon->show();
			return {};
		}
		if (auto weapon = m_weapon->on_click(clicked)) {
			m_chosen.weapon = *weapon;
			refresh_stats();
			m_done->show();
			return {};
		}
		if (*m_done == clicked) {
			m_log->entity(m_chosen.to_entity());
			m_log->endl();
			return screen::ToCombat {
				std::make_shared<game::Entity>(
					m_chosen.to_entity()
				)
			};
		}
		return {};
	}

	void
	NewCharScreen::refresh_stats()
	{
		if (m_chosen.is_ready())
			m_stats->update(m_chosen.to_entity());
	}

	// Chosen
	NewCharScreen::Chosen::Chosen(
			game::Entity::Race::Ptr race,
			int base_armor
	):
		race {race},
		base_armor {base_armor}
	{}

	bool
	NewCharScreen::Chosen::is_ready() const
	{ return !!class_template; }

	game::Entity
	NewCharScreen::Chosen::to_entity() const
	{
		if (!is_ready())
			throw ui::Exception {"Entity not ready yet."};
		return {"Player", base_attr, race, class_template, base_armor, armor, weapon};
	}
}
