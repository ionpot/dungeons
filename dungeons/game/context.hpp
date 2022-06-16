#pragma once

#include "class.hpp"
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
		const Class::Templates& class_templates() const;
		int roll_attribute();
		Entity::BaseAttributes roll_base_attr();

	private:
		util::dice::Engine m_dice_engine;
		util::dice::Input m_attribute_dice;
		Config::Armors m_armors;
		int m_base_armor;
		Class::Templates m_class_templates;
	};
}
