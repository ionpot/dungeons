#pragma once

#include "screen.hpp"

#include <ui/armor_select.hpp>
#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/new_attributes.hpp>
#include <ui/new_stats.hpp>
#include <ui/weapon_select.hpp>

#include <game/context.hpp>
#include <game/entity.hpp>
#include <game/log.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace widget = ionpot::widget;

	class NewCharScreen : public widget::Element {
	public:
		NewCharScreen(
			std::shared_ptr<game::Log>,
			std::shared_ptr<const ui::Context>,
			std::shared_ptr<game::Context>);

		std::optional<screen::Output> on_click(const widget::Element&) const;

	private:
		std::shared_ptr<game::Log> m_log;
		std::shared_ptr<ui::ClassSelect> m_class;
		std::shared_ptr<ui::NewAttributes> m_attributes;
		std::shared_ptr<ui::NewStats> m_stats;
		std::shared_ptr<ui::ArmorSelect> m_armor;
		std::shared_ptr<ui::WeaponSelect> m_weapon;
		std::shared_ptr<ui::Button> m_roll_attr;
		std::shared_ptr<ui::Button> m_done;
		std::shared_ptr<game::Entity> m_entity;

		void refresh_stats() const;
	};
}
