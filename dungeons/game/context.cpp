#include "context.hpp"

#include "attributes.hpp"
#include "config.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	Context::Context(
			std::shared_ptr<const Config> config,
			unsigned int seed
	):
		m_dice_engine {seed},
		m_attribute_dice {config->attribute_dice()}
	{}

	Attributes::Roll
	Context::roll_attributes()
	{ return {m_dice_engine, m_attribute_dice}; }
}
