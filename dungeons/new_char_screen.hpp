#pragma once

#include "screen.hpp"

#include <ui/armor_select.hpp>
#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/new_attributes.hpp>
#include <ui/new_stats.hpp>
#include <ui/weapon_select.hpp>

#include <game/class.hpp>
#include <game/context.hpp>
#include <game/entity.hpp>
#include <game/log.hpp>

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/group.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewCharScreen : public widget::Group {
	public:
		NewCharScreen(
			std::shared_ptr<game::Log>,
			std::shared_ptr<const ui::Context>,
			const game::Context&);

		std::optional<screen::Output> on_click(const widget::Element&);

	private:
		struct Chosen {
			game::Class::Template::Ptr class_template;
			game::Entity::BaseAttributes base_attr;
			game::Entity::Armor::Ptr armor;
			int base_armor;
			game::Entity::Weapon::Ptr weapon;

			Chosen(int base_armor);

			bool is_ready() const;
			game::Entity to_entity() const;
		};

		std::shared_ptr<game::Log> m_log;
		util::Size m_spacing;
		std::shared_ptr<ui::ClassSelect> m_class;
		std::shared_ptr<ui::NewAttributes> m_attributes;
		std::shared_ptr<ui::NewStats> m_stats;
		std::shared_ptr<ui::ArmorSelect> m_armor;
		std::shared_ptr<ui::WeaponSelect> m_weapon;
		std::shared_ptr<ui::Button> m_done;
		Chosen m_chosen;

		void log_new_char();
		void refresh_stats();
	};
}
