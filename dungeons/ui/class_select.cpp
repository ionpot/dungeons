#include "class_select.hpp"

#include "context.hpp"
#include "string.hpp"

#include <game/class_id.hpp>

#include <ionpot/widget/side_by_side.hpp>

#include <utility> // std::move
#include <vector>

#define BUTTON(id) {ui::string::class_id(id), id}

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	ClassSelect
	class_select(const Context& ctx)
	{
		using Button = ClassSelect::Button;
		auto buttons = Button::from(ctx, std::vector<Button::Input> {
			BUTTON(game::ClassId::warrior),
			BUTTON(game::ClassId::hybrid),
			BUTTON(game::ClassId::mage)
		});
		widget::side_by_side(buttons, ctx.button.spacing);
		return {std::move(buttons)};
	}
}
