#include "dice.hpp"

#include "config.hpp"
#include "entity.hpp"

namespace dungeons::game {
	Dice::Dice(const Config& config, unsigned int seed):
		Engine {seed},
		m_attribute {config.attribute_dice()}
	{}

	int
	Dice::roll_attribute()
	{ return roll(m_attribute); }

	Entity::Attributes
	Dice::roll_base_attr()
	{
		return {
			roll_attribute(),
			roll_attribute(),
			roll_attribute()
		};
	}
}
