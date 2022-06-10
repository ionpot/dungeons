#pragma once

#include "class_id.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Config {
	public:
		struct ClassTemplate {
			using Ptr = std::shared_ptr<const ClassTemplate>;
			ClassId id;
			int hp_bonus_per_level;
		};

		struct ClassTemplates {
			ClassTemplate::Ptr warrior;
			ClassTemplate::Ptr hybrid;
			ClassTemplate::Ptr mage;
		};

		struct HpMultipliers {
			int warrior;
			int hybrid;
			int mage;
		};

		Config(util::CfgFile&&);

		util::dice::Input attribute_dice() const;
		int base_armor() const;
		ClassTemplates class_templates() const;
		HpMultipliers hp_multipliers() const;

	private:
		util::CfgFile m_file;
	};
}
