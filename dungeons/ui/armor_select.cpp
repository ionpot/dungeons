#include "armor_select.hpp"

#include "context.hpp"
#include "radio_group.hpp"
#include "text.hpp"

#include <game/config.hpp>
#include <game/string.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::make_shared
#include <optional>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	ArmorSelect::ArmorSelect(
			const Context& ui,
			const game::Config::Armors& armors
	):
		m_title {std::make_shared<Text>(
			normal_text(ui, "Armor")
		)},
		m_radio {std::make_shared<Radio>(
			Radio::vertical(ui, game::string::armor, {
				armors.leather,
				armors.scale_mail
			})
		)}
	{
		children({m_title, m_radio});
		m_radio->place_after(*m_title, ui.button.spacing);
		m_title->center_y_to(*m_radio);
		update_size();
	}

	std::optional<ArmorSelect::Value>
	ArmorSelect::on_click(const widget::Element& elmt)
	{ return m_radio->on_click(elmt); }
}
