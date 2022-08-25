#include "entity_info.hpp"

#include "context.hpp"
#include "text.hpp"

#include <game/entity.hpp>
#include <game/string.hpp>

#include <memory> // std::make_shared

namespace dungeons::ui {
	namespace str = game::string;

	EntityInfo::EntityInfo(
			const Context& ui,
			const game::Entity& entity
	):
		primary {std::make_shared<Text>(
			ui.normal_text(str::primary(entity))
		)},
		secondary {std::make_shared<Text>(
			ui.normal_text(str::secondary_attr(entity))
		)},
		armor {std::make_shared<Text>(
			ui.normal_text("Armor: " + str::armor(entity))
		)},
		weapon {std::make_shared<Text>(
			ui.normal_text("Weapon: " + str::weapon_info(entity))
		)}
	{
		children({primary, secondary, armor, weapon});
		ui.stack_text(children());
		update_size();
	}
}
