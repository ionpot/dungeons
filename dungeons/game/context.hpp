#pragma once

#include "config.hpp"
#include "entity.hpp"

#include <ionpot/util/dice.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Context {
	public:
		Context(
				std::shared_ptr<const Config>,
				unsigned int seed);

		const Config::Armors& armors() const;
		int base_armor() const;
		const Config::ClassTemplates& class_templates() const;
		int roll_attribute();
		Entity::BaseAttributes roll_base_attr();
		const Config::Weapons& weapons() const;

	private:
		util::dice::Engine m_dice_engine;
		util::dice::Input m_attribute_dice;
		Config::Armors m_armors;
		int m_base_armor;
		Config::ClassTemplates m_class_templates;
		Config::Weapons m_weapons;
	};
}
