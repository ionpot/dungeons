#pragma once

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Config {
	public:
		Config(util::CfgFile&&);

		util::dice::Input attribute_dice() const;

	private:
		util::CfgFile m_file;
	};
}
