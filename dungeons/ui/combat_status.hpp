#pragma once

#include "context.hpp"
#include "text.hpp"

#include <game/combat.hpp>
#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/rows.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	class CombatStatus : public widget::Element {
	public:
		CombatStatus(std::shared_ptr<const Context>);

		void attack(const game::Combat::Attack&, int round);
		void goes_first(const game::Entity&);
		void end();

	private:
		std::shared_ptr<const Context> m_ui;
		std::shared_ptr<Text> m_first;
		std::shared_ptr<widget::Rows> m_rows;
		std::shared_ptr<Text> m_end;
	};
}
