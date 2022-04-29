#pragma once

#include "context.hpp"
#include "texture.hpp"

#include <ionpot/widget/box.hpp>
#include <ionpot/widget/click.hpp>
#include <ionpot/widget/hover.hpp>
#include <ionpot/widget/text_box.hpp>

#include <ionpot/sdl/cursor.hpp>
#include <ionpot/sdl/mouse.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	template<class T> // T = Box
	class Button : public widget::Box {
	public:
		Button(const Context& ctx, T&& box):
			widget::Box {box.size()},
			m_box {std::move(box)},
			m_hover {ctx.mouse},
			m_left_click {ctx.left_click},
			m_cursor_enter {ctx.cursor_hand},
			m_cursor_leave {ctx.cursor_arrow},
			m_dent {ctx.button.click_dent}
		{}

		void
		update(util::Point offset = {})
		{
			m_hover.update(m_box, position() + offset);
			if (m_hover.has_entered()) {
				m_cursor_enter->set();
			}
			if (m_hover.has_left()) {
				m_cursor_leave->set();
			}
		}

		void
		render(util::Point offset = {}) const
		{
			offset += position();
			if (m_hover.is_hovered()) {
				if (m_left_click->pressed_on(m_box, offset)) {
					offset += m_dent;
				}
			}
			m_box.render(offset);
		}

		void
		reset_cursor() const
		{ m_cursor_leave->set(); }

	private:
		T m_box;
		widget::Hover m_hover;
		std::shared_ptr<const widget::LeftClick> m_left_click;
		std::shared_ptr<const sdl::Cursor> m_cursor_enter;
		std::shared_ptr<const sdl::Cursor> m_cursor_leave;
		util::Point m_dent;
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
