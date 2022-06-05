#include "class_select.hpp"

#include "button.hpp"
#include "context.hpp"
#include "string.hpp"

#include <game/class_id.hpp>

#include <ionpot/util/vector.hpp>

#include <utility> // std::move

namespace dungeons::ui {
	namespace util = ionpot::util;

	ClassSelect
	class_select(const Context& ui)
	{
		auto buttons = ClassSelect::make_buttons(ui, string::class_id, {
			game::ClassId::warrior,
			game::ClassId::hybrid,
			game::ClassId::mage
		});
		auto refs = util::ptr_vector<widget::Box>(buttons);
		lay_buttons(ui, refs);
		return {std::move(buttons)};
	}
}
