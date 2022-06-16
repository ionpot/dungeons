#include "armor_select.hpp"

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

	ArmorSelect::ArmorSelect(const Context& ui, const game::Context& game):
		m_title {std::make_shared<Text>(
			normal_text(ui, "Armor")
		)},
		m_radio {std::make_shared<Radio>(
			Radio::horizontal(ui, string::armor, {
				game.armors().leather,
				game.armors().scale_mail
			})
		)}
	{
		elements({m_title});
		groups({m_radio});
		m_radio->place_after(*m_title, ui.button.spacing);
		m_title->center_y_to(*m_radio);
		update_size();
	}

	std::optional<ArmorSelect::Value>
	ArmorSelect::on_click(const widget::Element& elmt)
	{ return m_radio->on_click(elmt); }
}
