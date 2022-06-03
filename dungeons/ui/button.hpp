#pragma once

#include "context.hpp"
#include "texture.hpp"

#include <ionpot/widget/box.hpp>
#include <ionpot/widget/element.hpp>
#include <ionpot/widget/side_by_side.hpp>
#include <ionpot/widget/text_box.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <string>
#include <utility> // std::move

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	template<class T> // T = widget::Element
	class Button : public widget::Element {
	public:
		Button(const Context& ctx, T&& box):
			widget::Element {box.size()},
			m_box {std::move(box)},
			m_click_dent {ctx.button.click_dent}
		{ enable(); }

		widget::Element*
		find(util::Point point, util::Point offset = {})
		{
			if (clickable() && widget::Box::contains(point, offset))
				return this;
			return nullptr;
		}

		void
		disable()
		{ clickable(false); }

		void
		enable()
		{ clickable(true); }

		void
		render(util::Point offset = {}) const
		{
			if (clickable()) {
				if (held_down())
					offset += m_click_dent;
				widget::Element::render(m_box, offset);
			}
			else {
				widget::Element::render(m_box.text(), offset);
			}
		}

	private:
		T m_box;
		util::Point m_click_dent;
	};

	using UniqueButton = Button<widget::TextBox>;
	using SharedButton = Button<widget::SharedTextBox>;

	UniqueButton unique_button(
		const Context&,
		std::string text);

	SharedButton shared_button(
		const Context&,
		std::string text,
		std::shared_ptr<const Texture> box);

	Texture button_box(const Context&, util::Size content_size);

	util::Size button_size(const Context&, util::Size content_size);
	util::Size button_text_size(const Context& ctx, std::string content);

	template<class T> // T = Box[]
	void
	lay_buttons(const Context& ui, T& buttons)
	{ widget::side_by_side(buttons, ui.button.spacing); }
}
