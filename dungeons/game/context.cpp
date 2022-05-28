#include "context.hpp"

#include "class_id.hpp"
#include "config.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	Context::Context(
			std::shared_ptr<const Config> config,
			unsigned int seed
	):
		m_dice_engine {seed},
		m_attribute_dice {config->attribute_dice()},
		m_hp_multiplier {config->hp_multipliers()}
	{}

	int
	Context::roll_attribute()
	{ return m_dice_engine.roll(m_attribute_dice).total(); }

	int
	Context::hp_multiplier(ClassId id) const
	{
		switch (id) {
		case ClassId::warrior:
			return m_hp_multiplier.warrior;
		case ClassId::hybrid:
			return m_hp_multiplier.hybrid;
		case ClassId::mage:
			return m_hp_multiplier.mage;
		}
	}
}
