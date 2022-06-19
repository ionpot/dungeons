#include "entity.hpp"

#include "class.hpp"

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
	Entity::Entity(Class::Template::Ptr class_template, int base_armor):
		m_base {},
		m_class {class_template},
		m_armor {},
		m_base_armor {base_armor}
	{}

	int
	Entity::agility() const
	{ return m_base.agility; }

	Entity::Armor::Ptr
	Entity::armor() const
	{ return m_armor; }

	void
	Entity::armor(Armor::Ptr armor)
	{ m_armor = armor; }

	void
	Entity::base_attr(BaseAttributes attr)
	{ m_base = attr; }

	void
	Entity::class_template(Class::Template::Ptr t)
	{ m_class.set_template(t); }

	util::Percent
	Entity::dodge_chance() const
	{
		auto base = m_base.dodge_chance();
		return m_armor
			? m_armor->dodge_scale.apply_to(base)
			: base;
	}

	const Class&
	Entity::get_class() const
	{ return m_class; }

	int
	Entity::initiative() const
	{
		auto armor = m_armor ? m_armor->initiative : 0;
		auto weapon = m_weapon ? m_weapon->initiative : 0;
		return m_base.initiative() + armor + weapon;
	}

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
	Entity::total_armor() const
	{
		return m_base_armor
			+ (m_armor ? m_armor->value : 0);
	}

	int
	Entity::total_hp() const
	{ return m_base.hp() + m_class.hp_bonus(); }

	Entity::Weapon::Ptr
	Entity::weapon() const
	{ return m_weapon; }

	void
	Entity::weapon(Weapon::Ptr w)
	{ m_weapon = w; }

	util::Range
	Entity::weapon_damage() const
	{ return {weapon_damage_min(), weapon_damage_max()}; }

	int
	Entity::weapon_damage_bonus() const
	{ return strength() / 2; }

	int
	Entity::weapon_damage_min() const
	{
		return m_weapon
			? m_weapon->dice.min() + weapon_damage_bonus()
			: 0;
	}

	int
	Entity::weapon_damage_max() const
	{
		return m_weapon
			? m_weapon->dice.max() + weapon_damage_bonus()
			: 0;
	}
}
