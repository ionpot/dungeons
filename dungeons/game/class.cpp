#include "class.hpp"

namespace dungeons::game {
	Class::Class(Template::Ptr t, int level):
		m_template {t},
		m_level {level}
	{}

	Class::Template::Ptr
	Class::get_template() const
	{ return m_template; }

	int
	Class::hp_bonus() const
	{ return m_level * m_template->hp_bonus_per_level; }

	void
	Class::set_template(Template::Ptr t)
	{ m_template = t; }
}
