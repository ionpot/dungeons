#pragma once

#include "button.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/text_box.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <utility> // std::move

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	template<class T> // T = copyable value
	class RadioButton : public widget::Element {
	public:
		RadioButton(Button&& button, widget::TextBox chosen, T value):
			m_button {std::make_shared<Button>(std::move(button))},
			m_chosen {std::make_shared<widget::TextBox>(std::move(chosen))},
			m_value {value}
		{
			children({m_button, m_chosen});
			m_chosen->center_text();
			m_chosen->center_to(*m_button);
			update_size();
			m_chosen->hide();
		}

		void
		choose()
		{
			m_button->hide();
			m_chosen->show();
		}

		bool
		is_clicked(const widget::Element& elmt) const
		{ return *m_button == elmt;}

		void
		revert()
		{
			m_chosen->hide();
			m_button->show();
		}

		T
		value() const
		{ return m_value; }

	private:
		std::shared_ptr<Button> m_button;
		std::shared_ptr<widget::TextBox> m_chosen;
		T m_value;
	};
}
