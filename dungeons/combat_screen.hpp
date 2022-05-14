#pragma once

#include "screen.hpp"

#include <ui/button.hpp>
#include <ui/context.hpp>
#include <ui/text.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/log.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class CombatScreen {
	public:
		CombatScreen(
			std::shared_ptr<util::Log>,
			const ui::Context&,
			const screen::ToCombat&);

		widget::Element* find(util::Point);
		std::optional<screen::Output> on_click(const widget::Element&);
		void render() const;

	private:
		std::shared_ptr<util::Log> m_log;
		ui::Text m_text;
		ui::UniqueButton m_button;
	};
}
