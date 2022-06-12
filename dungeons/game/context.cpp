#include "context.hpp"

#include "class.hpp"
#include "config.hpp"
#include "entity.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	Context::Context(
			std::shared_ptr<const Config> config,
			unsigned int seed
	):
		m_dice_engine {seed},
		m_attribute_dice {config->attribute_dice()},
		m_base_armor {config->base_armor()},
		m_class_templates {config->class_templates()}
	{}

	int
	Context::base_armor() const
	{ return m_base_armor; }

	const Class::Templates&
	Context::class_templates() const
	{ return m_class_templates; }

	int
	Context::roll_attribute()
	{ return m_dice_engine.roll(m_attribute_dice); }

	Entity::BaseAttributes
	Context::roll_base_attr()
	{
		return {
			roll_attribute(),
			roll_attribute(),
			roll_attribute()
		};
	}
}
