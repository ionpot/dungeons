#pragma once

#include "class_id.hpp"

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr
#include <string>

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

		Config(util::CfgFile&&);

		util::dice::Input attribute_dice() const;

		int base_armor() const;

		ClassTemplates class_templates() const;

		ClassTemplate warrior_template() const;
		ClassTemplate hybrid_template() const;
		ClassTemplate mage_template() const;

	private:
		util::CfgFile m_file;

		ClassTemplate class_template(ClassId, std::string) const;
	};
}
