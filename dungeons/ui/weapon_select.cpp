#include "weapon_select.hpp"

#include "context.hpp"
#include "radio_group.hpp"
#include "string.hpp"
#include "text.hpp"

#include <game/context.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared
#include <optional>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	WeaponSelect::WeaponSelect(const Context& ui, const game::Context& game):
		m_title {std::make_shared<Text>(
			normal_text(ui, "Weapon")
		)},
		m_radio {std::make_shared<Radio>(
			Radio::horizontal(ui, string::weapon, {
				game.weapons().dagger,
				game.weapons().mace,
				game.weapons().longsword,
				game.weapons().halberd
			})
		)}
	{
		elements({m_title});
		groups({m_radio});
		m_radio->place_after(*m_title, ui.button.spacing);
		m_title->center_y_to(*m_radio);
		update_size();
	}

	std::optional<WeaponSelect::Value>
	WeaponSelect::on_click(const widget::Element& elmt)
	{ return m_radio->on_click(elmt); }
}
