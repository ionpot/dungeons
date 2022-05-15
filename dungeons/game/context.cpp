#include "context.hpp"

#include "attributes.hpp"

namespace dungeons::game {
	Context::Context(unsigned int seed):
		m_dice_engine {seed},
		m_attribute_dice {3, 6}
	{}

	Attributes::Roll
	Context::roll_attributes()
	{ return {m_dice_engine, m_attribute_dice}; }
}
