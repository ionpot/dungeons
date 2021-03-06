#pragma once

#include "context.hpp"
#include "label_value.hpp"

#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	class NewStats : public widget::Element {
	public:
		NewStats(std::shared_ptr<const Context>);

		void update(const game::Entity&);

	private:
		std::shared_ptr<LabelValue> m_hp;
		std::shared_ptr<LabelValue> m_armor;
		std::shared_ptr<LabelValue> m_dodge;
		std::shared_ptr<LabelValue> m_initiative;
		std::shared_ptr<LabelValue> m_will;
		std::shared_ptr<LabelValue> m_weapon;
	};
}
