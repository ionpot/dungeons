#include "config.hpp"

#include "class_id.hpp"

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

	Config::ClassTemplate
	Config::class_template(ClassId id, std::string section_name) const
	{
		auto section = m_file.find_section(section_name);
		return {id, section.find_pair("hp per level").to_int()};
	}

	Config::ClassTemplates
	Config::class_templates() const
	{
		return {
			std::make_shared<const ClassTemplate>(warrior_template()),
			std::make_shared<const ClassTemplate>(hybrid_template()),
			std::make_shared<const ClassTemplate>(mage_template())
		};
	}

	Config::ClassTemplate
	Config::warrior_template() const
	{ return class_template(ClassId::warrior, "warrior template"); }

	Config::ClassTemplate
	Config::hybrid_template() const
	{ return class_template(ClassId::hybrid, "hybrid template"); }

	Config::ClassTemplate
	Config::mage_template() const
	{ return class_template(ClassId::mage, "mage template"); }
}
