#include "entity.hpp"

#include "attributes.hpp"
#include "class_id.hpp"
#include "context.hpp"

#include <ionpot/util/percent.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	Entity::Entity(std::shared_ptr<const Context> game):
		m_attr {},
		m_class {game}
	{}

	const Attributes&
	Entity::attributes() const
	{ return m_attr; }

	void
	Entity::attributes(Attributes attr)
	{ m_attr = attr; }

	ClassId
	Entity::class_id() const
	{ return m_class.id(); }

	void
	Entity::class_id(ClassId id)
	{ m_class.id(id); }

	util::Percent
	Entity::dodge_chance() const
	{ return {m_attr.agility()}; }

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
