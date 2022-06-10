#include "class.hpp"

#include "class_id.hpp"

namespace dungeons::game {
	Class::Class(TemplatePtr t, int level):
		m_template {t},
		m_level {level}
	{}

	ClassId
	Class::id() const
	{ return m_template->id; }

	int
	Class::hp_bonus() const
	{ return m_level * m_template->hp_bonus_per_level; }

	void
	Class::set_template(TemplatePtr t)
	{ m_template = t; }
}
