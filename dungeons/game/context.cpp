#include "context.hpp"

#include "config.hpp"
#include "dice.hpp"
#include "entity.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	Context::Context(const Config& config, std::shared_ptr<Dice> dice):
		m_dice {dice},
		m_armors {config.armors()},
		m_base_armor {config.base_armor()},
		m_class_templates {config.class_templates()},
		m_weapons {config.weapons()}
	{}

	const Config::Armors&
	Context::armors() const
	{ return m_armors; }

	int
	Context::base_armor() const
	{ return m_base_armor; }

	const Config::ClassTemplates&
	Context::class_templates() const
	{ return m_class_templates; }

	std::shared_ptr<Dice>
	Context::dice() const
	{ return m_dice; }

	const Config::Weapons&
	Context::weapons() const
	{ return m_weapons; }
}
