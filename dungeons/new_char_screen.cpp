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
		m_spacing {ui->section_spacing},
		m_class {ui::class_select(*ui, game->class_templates)},
		m_attributes {std::make_shared<ui::NewAttributes>(ui, game)},
		m_stats {std::make_shared<ui::NewStats>(ui)},
		m_armor {std::make_shared<ui::ArmorSelect>(*ui, game->armors)},
		m_weapon {std::make_shared<ui::WeaponSelect>(*ui, game->weapons)},
		m_done {std::make_shared<ui::Button>(*ui, "Done")},
		m_chosen {game->races.human, game->base_armor}
	{
		elements({m_done});
		groups({m_class, m_attributes, m_stats, m_armor, m_weapon});

		m_class->position(ui->screen_margin);

		m_attributes->place_below(*m_class, m_spacing);

		m_attributes->hide();
		m_stats->hide();
		m_armor->hide();
		m_weapon->hide();

		m_done->hide();
	}

	void
	NewCharScreen::log_new_char()
	{
		m_log->put("New character");
		m_log->entity(m_chosen.to_entity());
		m_log->endl();
	}

	std::optional<screen::Output>
	NewCharScreen::on_click(const widget::Element& clicked)
	{
		if (auto chosen = m_class->on_click(clicked)) {
			m_chosen.class_template = *chosen;
			refresh_stats();
			if (m_attributes->hidden())
				m_attributes->show();
			return {};
		}
		if (auto rolled = m_attributes->on_click(clicked)) {
			m_chosen.base_attr = *rolled;
			refresh_stats();
			if (m_stats->hidden()) {
				m_stats->place_after(*m_attributes, m_spacing);
				m_stats->show();
			}
			if (m_armor->hidden()) {
				m_armor->place_below(*m_attributes, m_spacing);
				m_armor->show();
			}
			return {};
		}
		if (auto armor = m_armor->on_click(clicked)) {
			m_chosen.armor = *armor;
			refresh_stats();
			if (m_weapon->hidden()) {
				m_weapon->place_below(*m_armor, m_spacing);
				m_weapon->show();
			}
			return {};
		}
		if (auto weapon = m_weapon->on_click(clicked)) {
			m_chosen.weapon = *weapon;
			refresh_stats();
			if (m_done->hidden()) {
				m_done->place_after(*m_weapon, m_spacing);
				m_done->center_y_to(*m_weapon);
				m_done->show();
			}
			return {};
		}
		if (*m_done == clicked) {
			log_new_char();
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
		return {base_attr, race, class_template, base_armor, armor, weapon};
	}
}
