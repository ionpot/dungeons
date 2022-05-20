#include "entity.hpp"

#include "attributes.hpp"
#include "class.hpp"

namespace dungeons::game {
	const Attributes&
	Entity::attributes() const
	{ return m_attr; }

	void
	Entity::attributes(Attributes attr)
	{ m_attr = attr; }

	Class
	Entity::get_class() const
	{ return m_class; }

	void
	Entity::set_class(Class c)
	{ m_class = c; }
}
