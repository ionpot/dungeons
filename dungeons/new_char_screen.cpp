#include "new_char_screen.hpp"

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/string.hpp>

#include <game/context.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/log.hpp>
#include <ionpot/util/point.hpp>

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
		m_select {ui::class_select(*ui, *game)},
		m_attributes {ui, game},
		m_stats {ui},
		m_done {std::make_shared<ui::Button>(*ui, "Done")},
		m_new {},
		m_base_armor {game->base_armor()}
	{
		m_select.position(ui->screen_margin);

		m_attributes.place_below(m_select, m_spacing);

		m_attributes.hide();
		m_stats.hide();

		m_done->hide();
	}

	std::shared_ptr<widget::Element>
	NewCharScreen::find(util::Point point)
	{
		if (auto found = widget::find(m_select, point))
			return found;
		if (auto found = widget::find(m_attributes, point))
			return found;
		if (widget::contains(*m_done, point))
			return m_done;
		return {};
	}

	void
	NewCharScreen::log_new_char()
	{
		m_log->put("New character");
		namespace str = ui::string;
		const auto& entity = *m_new;
		m_log->pair(
			str::class_id(entity) + ":",
			str::primary_attr(entity));
		m_log->put(str::secondary_attr(entity));
		m_log->endl();
	}

	std::optional<screen::Output>
	NewCharScreen::on_click(const widget::Element& clicked)
	{
		if (auto chosen = m_select.on_click(clicked)) {
			if (m_new)
				m_new->class_template(*chosen);
			else
				m_new.emplace(*chosen, m_base_armor);
			m_stats.update(*m_new);
			if (m_attributes.hidden())
				m_attributes.show();
			return {};
		}
		if (auto rolled = m_attributes.on_click(clicked)) {
			m_new->attributes(*rolled);
			m_stats.update(*m_new);
			if (m_stats.hidden()) {
				m_stats.place_after(m_attributes, m_spacing);
				m_stats.show();
			}
			if (m_done->hidden()) {
				m_done->place_below(m_attributes, m_spacing);
				m_done->show();
			}
			return {};
		}
		if (*m_done == clicked) {
			log_new_char();
			return screen::ToCombat {m_new->get_class().id()};
		}
		return {};
	}

	void
	NewCharScreen::render() const
	{
		widget::render(m_select);
		widget::render(m_attributes);
		widget::render(m_stats);
		widget::render(*m_done);
	}
}
