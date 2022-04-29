#include "class_select.hpp"

#include "context.hpp"

#include <game/class.hpp>

#include <ionpot/widget/side_by_side.hpp>

#include <utility> // std::move
#include <vector>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	ClassSelect
	class_select(const Context& ctx)
	{
		using Button = ClassSelect::Button;
		using Value = game::Class;
		auto buttons = Button::from(ctx, std::vector<Button::Input> {
			{"Warrior", Value::warrior},
			{"Hybrid", Value::hybrid},
			{"Mage", Value::mage}
		});
		widget::side_by_side(buttons, ctx.button.spacing);
		return {std::move(buttons)};
	}
}
