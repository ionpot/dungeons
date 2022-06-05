#pragma once

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/new_attributes.hpp>
#include <ui/new_stats.hpp>

#include <game/context.hpp>
#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/log.hpp>
#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewCharScreen {
	public:
		NewCharScreen(
			std::shared_ptr<util::Log>,
			std::shared_ptr<const ui::Context>,
			std::shared_ptr<game::Context>);

		std::shared_ptr<widget::Element> find(util::Point);
		std::optional<screen::Output> on_click(const widget::Element&);
		void render() const;

	private:
		std::shared_ptr<util::Log> m_log;
		util::Size m_spacing;
		ui::ClassSelect m_select;
		ui::NewAttributes m_attributes;
		ui::NewStats m_stats;
		std::shared_ptr<ui::Button> m_done;
		game::Entity m_new;

		void log_new_char();
	};
}
