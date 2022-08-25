#pragma once

#include "context.hpp"

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
		void level_up(const game::Entity&);

	private:
		std::shared_ptr<const Context> m_ui;
		std::shared_ptr<widget::Rows> m_rows;
	};
}
