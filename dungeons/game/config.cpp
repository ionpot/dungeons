#include "config.hpp"

#include "class_id.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

#include <memory> // std::make_shared
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

	Config::ClassTemplates
	Config::class_templates() const
	{
		auto hp = hp_multipliers();
		return {
			std::make_shared<const ClassTemplate>(ClassTemplate {
				ClassId::warrior, hp.warrior
			}),
			std::make_shared<const ClassTemplate>(ClassTemplate {
				ClassId::hybrid, hp.hybrid
			}),
			std::make_shared<const ClassTemplate>(ClassTemplate {
				ClassId::mage, hp.mage
			})
		};
	}

	Config::HpMultipliers
	Config::hp_multipliers() const
	{
		auto section = m_file.find_section("hp multipliers");
		return {
			section.find_pair("warrior").to_int(),
			section.find_pair("hybrid").to_int(),
			section.find_pair("mage").to_int()
		};
	}
}
