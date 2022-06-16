#pragma once

#include "screen.hpp"

#include <ui/armor_select.hpp>
#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/new_attributes.hpp>
#include <ui/new_stats.hpp>

#include <game/context.hpp>
#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/group.hpp>

#include <ionpot/util/log.hpp>
#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewCharScreen : public widget::Group {
	public:
		NewCharScreen(
			std::shared_ptr<util::Log>,
			std::shared_ptr<const ui::Context>,
			std::shared_ptr<game::Context>);

		std::optional<screen::Output> on_click(const widget::Element&);

	private:
		std::shared_ptr<util::Log> m_log;
		util::Size m_spacing;
		std::shared_ptr<ui::ClassSelect> m_class;
		std::shared_ptr<ui::NewAttributes> m_attributes;
		std::shared_ptr<ui::NewStats> m_stats;
		std::shared_ptr<ui::ArmorSelect> m_armor;
		std::shared_ptr<ui::Button> m_done;
		std::optional<game::Entity> m_new;
		int m_base_armor;

		void log_new_char();
	};
}
