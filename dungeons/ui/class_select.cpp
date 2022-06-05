#include "class_select.hpp"

#include "button.hpp"
#include "context.hpp"
#include "string.hpp"

#include <game/class_id.hpp>

#include <utility> // std::move

namespace dungeons::ui {
	ClassSelect
	class_select(const Context& ui)
	{
		auto buttons = ClassSelect::make_buttons(ui, string::class_id, {
			game::ClassId::warrior,
			game::ClassId::hybrid,
			game::ClassId::mage
		});
		lay_buttons(ui, buttons);
		return {std::move(buttons)};
	}
}
