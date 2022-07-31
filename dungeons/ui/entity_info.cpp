#include "entity_info.hpp"

#include "context.hpp"
#include "text.hpp"

#include <game/entity.hpp>
#include <game/string.hpp>

#include <memory> // std::make_shared, std::shared_ptr

namespace dungeons::ui {
	namespace str = game::string;

	EntityInfo::EntityInfo(
			std::shared_ptr<const Context> ui,
			std::shared_ptr<const game::Entity> entity
	):
		ui {ui},
		entity {entity},
		primary {std::make_shared<Text>(
			ui->normal_text(str::primary(*entity))
		)},
		secondary {std::make_shared<Text>(
			ui->normal_text(str::secondary_attr(*entity))
		)},
		armor {std::make_shared<Text>(
			ui->normal_text("Armor: " + str::armor(*entity))
		)},
		weapon {std::make_shared<Text>(
			ui->normal_text("Weapon: " + str::weapon(*entity))
		)}
	{
		children({primary, secondary, armor, weapon});
		ui->stack_text(children());
		update_size();
	}

	void
	EntityInfo::update()
	{
		secondary->swap(
			ui->normal_text(
				str::secondary_attr(*entity)));
	}
}
