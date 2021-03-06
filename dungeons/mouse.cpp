#include "mouse.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/mouse.hpp>

#include <ionpot/sdl/mouse.hpp>

#include <memory> // std::shared_ptr
#include <utility> // std::move

namespace dungeons {
	namespace sdl = ionpot::sdl;
	namespace widget = ionpot::widget;

	Mouse::Mouse(sdl::Mouse&& mouse):
		widget::Mouse {std::move(mouse)},
		m_previous_clickable {false}
	{}

	void
	Mouse::hovered(std::shared_ptr<widget::Element> elmt)
	{
		widget::Mouse::hovered(elmt);
		auto current = elmt && elmt->clickable();
		auto previous = m_previous_clickable;
		if (!previous && current)
			m_hand.set();
		else if (previous && !current)
			m_arrow.set();
		m_previous_clickable = current;
	}
}
