#include "level_up.hpp"

#include "button_group.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <game/entity.hpp>
#include <game/string.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	namespace {
		using Attr = game::Entity::Attributes;

		std::string
		s_button_str(const Attr::Id& id)
		{ return "+ " + game::string::attribute(id); }
	}

	LevelUp::LevelUp(std::shared_ptr<const Context> ui):
		m_remaining {std::make_shared<LabelValue>(ui, "Points remaining:")},
		m_buttons {std::make_shared<Buttons>(*ui, s_button_str, Attr::ids)}
	{
		children({m_remaining, m_buttons});
		m_buttons->vertical(*ui);
		m_buttons->left_align_text(*ui);
		m_buttons->place_below(*m_remaining, ui->section_spacing);
		refresh();
	}

	bool
	LevelUp::done() const
	{ return m_level_up.done(); }

	bool
	LevelUp::on_click(const widget::Element& clicked)
	{
		if (auto value = m_buttons->on_click(clicked)) {
			m_level_up.attributes.add(*value);
			refresh();
			return true;
		}
		return false;
	}

	void
	LevelUp::refresh()
	{
		auto points = m_level_up.points_remaining();
		m_remaining->value(points);
		m_buttons->visible(points > 0);
		update_size();
	}

	const game::Entity::LevelUp&
	LevelUp::state() const
	{ return m_level_up; }

	void
	LevelUp::state(game::Entity::LevelUp lvup)
	{ m_level_up = lvup; refresh(); }
}
