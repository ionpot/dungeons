#pragma once

#include "context.hpp"
#include "radio_group.hpp"
#include "text.hpp"

#include <game/config.hpp>
#include <game/weapon.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	class WeaponSelect : public widget::Element {
	public:
		using Value = game::Weapon::Ptr;
		using Radio = RadioGroup<Value>;

		WeaponSelect(const Context&, const game::Config::Weapons&);

		std::optional<Value> on_click(const widget::Element&);

	private:
		std::shared_ptr<Text> m_title;
		std::shared_ptr<Radio> m_radio;
	};
}
