#pragma once

#include "context.hpp"
#include "radio_group.hpp"
#include "text.hpp"

#include <game/armor.hpp>
#include <game/config.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	class ArmorSelect : public widget::Element {
	public:
		using Value = game::Armor::Ptr;
		using Radio = RadioGroup<Value>;

		ArmorSelect(const Context&, const game::Config::Armors&);

		std::optional<Value> on_click(const widget::Element&);

	private:
		std::shared_ptr<Text> m_title;
		std::shared_ptr<Radio> m_radio;
	};
}
