#include "context.hpp"

#include "config.hpp"
#include "dice.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	Context::Context(const Config& config, std::shared_ptr<Dice> dice):
		dice {dice},
		armors {config.armors()},
		base_armor {config.base_armor()},
		class_templates {config.class_templates()},
		weapons {config.weapons()}
	{}
}
