#include "class_select.hpp"

#include "context.hpp"
#include "string.hpp"

#include <game/context.hpp>

namespace dungeons::ui {
	ClassSelect
	class_select(const Context& ui, const game::Context& game)
	{
		const auto& templates = game.class_templates();
		return ClassSelect::horizontal(ui, string::class_id, {
			templates.warrior,
			templates.hybrid,
			templates.mage
		});
	}
}
