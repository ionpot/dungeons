#pragma once

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/mouse.hpp>

#include <ionpot/sdl/mouse.hpp>
#include <ionpot/sdl/system_cursor.hpp>

#include <memory> // std::shared_ptr

namespace dungeons {
	namespace sdl = ionpot::sdl;
	namespace widget = ionpot::widget;

	class Mouse : public widget::Mouse {
	public:
		Mouse(sdl::Mouse&&);

		using widget::Mouse::hovered;
		void hovered(std::shared_ptr<widget::Element>);

	private:
		bool m_previous_clickable;
		sdl::SystemCursor::Arrow m_arrow;
		sdl::SystemCursor::Hand m_hand;
	};
}
