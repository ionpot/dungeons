#include "new_char_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/string.hpp>

#include <game/context.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	NewCharScreen::NewCharScreen(
			std::shared_ptr<util::Log> log,
			std::shared_ptr<const ui::Context> ui,
			std::shared_ptr<game::Context> game
	):
		m_log {log},
		m_spacing {ui->section_spacing},
		m_class {ui::class_select(*ui, *game)},
		m_attributes {std::make_shared<ui::NewAttributes>(ui, game)},
		m_stats {std::make_shared<ui::NewStats>(ui)},
		m_armor {std::make_shared<ui::ArmorSelect>(*ui, *game)},
		m_done {std::make_shared<ui::Button>(*ui, "Done")},
		m_base_armor {game->base_armor()},
		m_chosen_class {},
		m_rolled_attr {},
		m_chosen_armor {}
	{
		elements({m_done});
		groups({m_class, m_attributes, m_stats, m_armor});

		m_class->position(ui->screen_margin);

		m_attributes->place_below(*m_class, m_spacing);

		m_attributes->hide();
		m_stats->hide();
		m_armor->hide();

		m_done->hide();
	}

	game::Entity
	NewCharScreen::get_entity() const
	{
		game::Entity entity {m_chosen_class, m_base_armor};
		entity.base_attr(*m_rolled_attr);
		entity.armor(m_chosen_armor);
		return entity;
	}

	void
	NewCharScreen::log_new_char()
	{
		m_log->put("New character");
		namespace str = ui::string;
		const auto& entity = get_entity();
		m_log->pair(
			str::class_id(entity) + ":",
			str::primary_attr(entity));
		m_log->put(str::secondary_attr(entity));
		m_log->endl();
	}

	std::optional<screen::Output>
	NewCharScreen::on_click(const widget::Element& clicked)
	{
		if (auto chosen = m_class->on_click(clicked)) {
			m_chosen_class = *chosen;
			refresh_stats();
			if (m_attributes->hidden())
				m_attributes->show();
			return {};
		}
		if (auto rolled = m_attributes->on_click(clicked)) {
			m_rolled_attr = rolled;
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
			m_chosen_armor = *armor;
			refresh_stats();
			if (m_done->hidden()) {
				m_done->place_below(*m_armor, m_spacing);
				m_done->show();
			}
			return {};
		}
		if (*m_done == clicked) {
			log_new_char();
			return screen::ToCombat {m_chosen_class->id};
		}
		return {};
	}

	void
	NewCharScreen::refresh_stats()
	{ m_stats->update(get_entity()); }
}
