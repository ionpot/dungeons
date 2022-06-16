#include "config.hpp"

#include "class.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

#include <memory> // std::make_shared
#include <string>
#include <utility> // std::move

namespace dungeons::game {
	namespace util = ionpot::util;

	Config::Config(util::CfgFile&& file):
		m_file {std::move(file)}
	{}

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

	util::dice::Input
	Config::attribute_dice() const
	{
		return m_file.find_pair("attribute roll").to_dice();
	}

	int
	Config::base_armor() const
	{
		return m_file.find_pair("base armor").to_int();
	}

	Class::Template
	Config::class_template(Class::Id id, std::string section_name) const
	{
		auto section = m_file.find_section(section_name);
		return {id, section.find_pair("hp per level").to_int()};
	}

	Class::Templates
	Config::class_templates() const
	{
		return {
			std::make_shared<const Class::Template>(warrior_template()),
			std::make_shared<const Class::Template>(hybrid_template()),
			std::make_shared<const Class::Template>(mage_template())
		};
	}

	Class::Template
	Config::warrior_template() const
	{ return class_template(Class::Id::warrior, "warrior template"); }

	Class::Template
	Config::hybrid_template() const
	{ return class_template(Class::Id::hybrid, "hybrid template"); }

	Class::Template
	Config::mage_template() const
	{ return class_template(Class::Id::mage, "mage template"); }
}
