#include "config.hpp"

#include "class.hpp"
#include "entity.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/deviation.hpp>
#include <ionpot/util/dice.hpp>

#include <memory> // std::make_shared
#include <string>
#include <utility> // std::move
#include <vector>

namespace dungeons::game {
	namespace util = ionpot::util;
	namespace dice = util::dice;

	Entity::Armor::Ptr
	Config::Armors::roll(dice::Engine& dice) const
	{
		return dice.pick(std::vector {
			leather, scale_mail
		});
	}

	Entity::Attributes
	Config::Attributes::roll(dice::Engine& dice) const
	{
		return {
			dice.roll(strength),
			dice.roll(agility),
			dice.roll(intellect)
		};
	}

	Class::Template::Ptr
	Config::ClassTemplates::roll(dice::Engine& dice) const
	{
		return dice.pick(std::vector {
			warrior, hybrid, mage
		});
	}

	Entity::Weapon::Ptr
	Config::Weapons::roll(dice::Engine& dice) const
	{
		return dice.pick(std::vector {
			dagger, mace, longsword, halberd
		});
	}

	// Config
	Config::Config(util::CfgFile&& file):
		m_file {std::move(file)}
	{}

	Config::Attributes
	Config::attributes(std::string section_name) const
	{
		auto section = m_file.find_section(section_name);
		return {
			section.find_pair("strength").to_dice(),
			section.find_pair("agility").to_dice(),
			section.find_pair("intellect").to_dice()
		};
	}

	Entity::Armor
	Config::armor(Entity::Armor::Id id, std::string section_name) const
	{
		auto section = m_file.find_section(section_name);
		return {
			id,
			section.find_pair("armor value").to_int(),
			section.find_pair("initiative bonus").to_int(),
			section.find_pair("dodge scale").to_scale()
		};
	}

	Config::Armors
	Config::armors() const
	{
		using Armor = Entity::Armor;
		auto make = std::make_shared<const Armor, Armor&&>;
		return {
			make(armor(Armor::Id::leather, "leather armor")),
			make(armor(Armor::Id::scale_mail, "scale mail armor"))
		};
	}

	int
	Config::base_armor() const
	{
		return m_file.find_pair("base armor").to_int();
	}

	Class::Template
	Config::class_template(
			Class::Template::Id id,
			std::string section_name) const
	{
		auto section = m_file.find_section(section_name);
		return {id, section.find_pair("hp per level").to_int()};
	}

	Config::ClassTemplates
	Config::class_templates() const
	{
		using Template = Class::Template;
		auto make = std::make_shared<const Template, Template&&>;
		return {
			make(class_template(Template::Id::warrior, "warrior template")),
			make(class_template(Template::Id::hybrid, "hybrid template")),
			make(class_template(Template::Id::mage, "mage template"))
		};
	}

	util::Deviation
	Config::enemy_level_deviation() const
	{ return m_file.find_pair("enemy level deviation").to_deviation(); }

	Config::Attributes
	Config::human_attributes() const
	{ return attributes("human attributes"); }

	int
	Config::level_up_attributes() const
	{
		return m_file.find_section("level up")
			.find_pair("attribute points").to_int();
	}

	Config::Attributes
	Config::orc_attributes() const
	{ return attributes("orc attributes"); }

	Entity::Race
	Config::race(Entity::Race::Id id, std::string section_name) const
	{
		auto section = m_file.find_section(section_name);
		return {
			id,
			Entity::Attributes {
				section.find_pair("strength").to_int(),
				section.find_pair("agility").to_int(),
				section.find_pair("intellect").to_int()
			}
		};
	}

	Config::Races
	Config::races() const
	{
		using Race = Entity::Race;
		auto make = std::make_shared<const Race, Race&&>;
		return {
			make(race(Race::Id::human, "human bonus")),
			make(race(Race::Id::orc, "orc bonus"))
		};
	}

	Entity::Weapon
	Config::weapon(Entity::Weapon::Id id, std::string section_name) const
	{
		auto section = m_file.find_section(section_name);
		return {
			id,
			section.find_pair("damage dice").to_dice(),
			section.find_pair("initiative bonus").to_int()
		};
	}

	Config::Weapons
	Config::weapons() const
	{
		using Weapon = Entity::Weapon;
		auto make = std::make_shared<const Weapon, Weapon&&>;
		return {
			make(weapon(Weapon::Id::dagger, "dagger")),
			make(weapon(Weapon::Id::mace, "mace")),
			make(weapon(Weapon::Id::longsword, "longsword")),
			make(weapon(Weapon::Id::halberd, "halberd"))
		};
	}
}
