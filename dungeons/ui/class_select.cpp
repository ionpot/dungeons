#include "class_select.hpp"

#include "context.hpp"
#include "string.hpp"

#include <game/class_id.hpp>

namespace dungeons::ui {
	ClassSelect
	class_select(const Context& ui)
	{
		return ClassSelect::horizontal(ui, string::class_id, {
			game::ClassId::warrior,
			game::ClassId::hybrid,
			game::ClassId::mage
		});
	}
}
