#pragma once

#include "config.hpp"
#include "dice.hpp"
#include "entity.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Context {
	public:
		Context(const Config&, std::shared_ptr<Dice>);

		const Config::Armors& armors() const;
		int base_armor() const;
		const Config::ClassTemplates& class_templates() const;
		std::shared_ptr<Dice> dice() const;
		const Config::Weapons& weapons() const;

	private:
		std::shared_ptr<Dice> m_dice;
		Config::Armors m_armors;
		int m_base_armor;
		Config::ClassTemplates m_class_templates;
		Config::Weapons m_weapons;
	};
}
