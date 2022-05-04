#pragma once

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/class_select.hpp>
#include <ui/context.hpp>
#include <ui/new_attributes.hpp>

#include <game/class.hpp>

#include <ionpot/widget/click.hpp>

#include <ionpot/sdl/event.hpp>
#include <ionpot/sdl/mouse.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewCharScreen {
	public:
		NewCharScreen(
			std::shared_ptr<util::Log>,
			std::shared_ptr<const ui::Context>);

		std::optional<screen::Output> handle(const sdl::Event&);
		void render() const;
		void update();

	private:
		std::shared_ptr<util::Log> m_log;
		std::shared_ptr<const ui::Context> m_ui;
		std::shared_ptr<sdl::Mouse> m_mouse;
		std::shared_ptr<widget::LeftClick> m_left_click;
		ui::ClassSelect m_select;
		ui::NewAttributes m_attributes;
		ui::UniqueButton m_done;
		std::optional<game::Class> m_class_chosen;
		std::optional<ui::NewAttributes::Value> m_rolled_attr;
	};
}
