#include "entity_info.hpp"

#include "context.hpp"
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
			ui.normal_text(game::string::primary(entity))
		)},
		secondary {std::make_shared<Text>(
			ui.normal_text(game::string::secondary_attr(entity))
		)},
		armor {std::make_shared<Text>(
			ui.normal_text("Armor: " + game::string::armor(entity))
		)},
		weapon {std::make_shared<Text>(
			ui.normal_text("Weapon: " + game::string::weapon(entity))
		)}
	{
		children({primary, secondary, armor, weapon});
		ui.stack_text(children());
		update_size();
	}
}
