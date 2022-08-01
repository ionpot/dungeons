#pragma once

#include <memory> // std::shared_ptr

namespace dungeons::game {
	struct Class {
		struct Template {
			using Ptr = std::shared_ptr<const Template>;
			enum class Id { warrior, hybrid, mage } id;
			int hp_bonus_per_level;
		};

		Template::Ptr base_template;
		int level {1};

		int hp_bonus() const;
	};
}
