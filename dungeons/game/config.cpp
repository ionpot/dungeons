#include "config.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

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
