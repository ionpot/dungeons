#include "entity.hpp"

#include "class.hpp"
#include "context.hpp"

#include <ionpot/util/percent.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	// BaseAttributes
	using BaseAttributes = Entity::BaseAttributes;

	BaseAttributes::BaseAttributes(int str, int agi, int intel):
		strength {str},
		agility {agi},
		intellect {intel}
	{}

	BaseAttributes::BaseAttributes(Context& game):
		BaseAttributes {
			game.roll_attribute(),
			game.roll_attribute(),
			game.roll_attribute()
		}
	{}

	int
	BaseAttributes::hp() const
	{ return strength; }

	int
	BaseAttributes::initiative() const
	{ return agility + intellect; }

	util::Percent
	BaseAttributes::dodge_chance() const
	{ return {agility}; }

	util::Percent
	BaseAttributes::resist_chance() const
	{ return {intellect}; }

	// Entity
	Entity::Entity(Class::TemplatePtr class_template, int armor):
		m_base {},
		m_class {class_template},
		m_armor {armor}
	{}

	int
	Entity::agility() const
	{ return m_base.agility; }

	int
	Entity::armor() const
	{ return m_armor; }

	void
	Entity::base_attr(BaseAttributes attr)
	{ m_base = attr; }

	void
	Entity::class_template(Class::TemplatePtr t)
	{ m_class.set_template(t); }

	util::Percent
	Entity::dodge_chance() const
	{ return m_base.dodge_chance(); }

	const Class&
	Entity::get_class() const
	{ return m_class; }

	int
	Entity::initiative() const
	{ return m_base.initiative(); }

	int
	Entity::intellect() const
	{ return m_base.intellect; }

	util::Percent
	Entity::resist_chance() const
	{ return m_base.resist_chance(); }

	int
	Entity::strength() const
	{ return m_base.strength; }

	int
	Entity::total_hp() const
	{ return m_base.hp() + m_class.hp_bonus(); }
}
