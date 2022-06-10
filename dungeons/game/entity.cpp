#include "entity.hpp"

#include "attributes.hpp"
#include "class.hpp"

#include <ionpot/util/percent.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	Entity::Entity(Class::TemplatePtr class_template, int armor):
		m_attr {},
		m_class {class_template},
		m_armor {armor}
	{}

	int
	Entity::armor() const
	{ return m_armor; }

	const Attributes&
	Entity::attributes() const
	{ return m_attr; }

	void
	Entity::attributes(Attributes attr)
	{ m_attr = attr; }

	void
	Entity::class_template(Class::TemplatePtr t)
	{ m_class.set_template(t); }

	util::Percent
	Entity::dodge_chance() const
	{ return {m_attr.agility()}; }

	const Class&
	Entity::get_class() const
	{ return m_class; }

	int
	Entity::initiative() const
	{ return m_attr.agility() + m_attr.intellect(); }

	util::Percent
	Entity::resist_chance() const
	{ return {m_attr.intellect()}; }

	int
	Entity::total_hp() const
	{ return m_attr.strength() + m_class.hp_bonus(); }
}
