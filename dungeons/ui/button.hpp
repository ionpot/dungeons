#pragma once

#include "context.hpp"
#include "texture.hpp"

#include <ionpot/widget/element.hpp>
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
		{ clickable(true); }

		void
		render(util::Point offset = {}) const
		{
			if (held_down()) {
				offset += m_click_dent;
			}
			widget::Element::render(m_box, offset);
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

	Texture button_box(const Context&, util::Size box_size);
}
