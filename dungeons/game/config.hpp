#pragma once

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Config {
	public:
		struct HpMultipliers {
			int warrior;
			int hybrid;
			int mage;
		};

		Config(util::CfgFile&&);

		util::dice::Input attribute_dice() const;
		int base_armor() const;
		HpMultipliers hp_multipliers() const;

	private:
		util::CfgFile m_file;
	};
}
