#pragma once

#include "button_group.hpp"

#include <ionpot/widget/element.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	template<class T> // T = copyable value
	class RadioGroup : public TwoStateButtonGroup<T> {
	public:
		using Parent = TwoStateButtonGroup<T>;
		using Parent::TwoStateButtonGroup;

		std::optional<T>
		on_click(const widget::Element& elmt)
		{
			if (auto button = Parent::on_click(elmt)) {
				if (button == m_chosen)
					return {};
				if (m_chosen) {
					m_chosen->normal();
					m_chosen->clickable(true);
				}
				m_chosen = button;
				m_chosen->active();
				m_chosen->clickable(false);
				return m_chosen->value();
			}
			return {};
		}

	private:
		std::shared_ptr<typename Parent::Button> m_chosen;
	};
}
