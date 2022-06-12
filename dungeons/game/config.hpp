#pragma once

#include "class.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

#include <string>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Config {
	public:
		Config(util::CfgFile&&);

		util::dice::Input attribute_dice() const;

		int base_armor() const;

		Class::Templates class_templates() const;

		Class::Template warrior_template() const;
		Class::Template hybrid_template() const;
		Class::Template mage_template() const;

	private:
		util::CfgFile m_file;

		Class::Template class_template(Class::Id, std::string) const;
	};
}
