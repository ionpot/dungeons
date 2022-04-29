#pragma once

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/context.hpp>
#include <ui/text.hpp>

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

	class CombatScreen {
	public:
		CombatScreen(
			std::shared_ptr<util::Log>,
			const ui::Context&,
			const screen::ToCombat&);

		std::optional<screen::Output> handle(const sdl::Event&);
		void render() const;
		void update();

	private:
		std::shared_ptr<util::Log> m_log;
		std::shared_ptr<sdl::Mouse> m_mouse;
		std::shared_ptr<widget::LeftClick> m_left_click;
		ui::Text m_text;
		ui::UniqueButton m_button;
	};
}
