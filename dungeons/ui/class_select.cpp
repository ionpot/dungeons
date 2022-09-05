#include "class_select.hpp"

#include "context.hpp"

#include <game/config.hpp>
#include <game/string.hpp>

namespace dungeons::ui {
	ClassSelect::ClassSelect(
			const Context& ui,
			const game::Config::ClassTemplates& templates
	):
		Parent {ui, game::string::class_id, {
			templates.warrior,
			templates.hybrid,
			templates.mage
		}}
	{
		horizontal(ui);
		center_text();
	}
}
