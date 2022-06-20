#include "entity_info.hpp"

#include "text.hpp"

#include <game/entity.hpp>
#include <game/string.hpp>

#include <memory> // std::make_shared

namespace dungeons::ui {
	EntityInfo::EntityInfo(
			const Context& ui,
			const game::Entity& entity
	):
		primary {std::make_shared<Text>(
			normal_text(ui,
				game::string::race(entity)
				+ " "
				+ game::string::class_id(entity)
				+ " "
				+ game::string::primary_attr(entity)
			)
		)},
		secondary {std::make_shared<Text>(
			normal_text(ui, game::string::secondary_attr(entity))
		)},
		armor {std::make_shared<Text>(
			normal_text(ui, "Armor: " + game::string::armor(entity))
		)},
		weapon {std::make_shared<Text>(
			normal_text(ui, "Weapon: " + game::string::weapon(entity))
		)}
	{
		elements({primary, secondary, armor, weapon});
		stack_text(ui, elements());
		update_size();
	}
}
