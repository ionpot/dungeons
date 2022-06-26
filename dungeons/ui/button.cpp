#include "button.hpp"

#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/element.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr
#include <string>
#include <utility> // std::move

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	Button::Button(
			const Context& ui,
			Text&& text,
			std::shared_ptr<const Texture> box
	):
		widget::Element {box->size()},
		m_text {std::move(text)},
		m_box {box},
		m_click_dent {ui.button.click_dent}
	{
		m_text.center_to(*m_box);
		enable();
	}

	Button::Button(
			const Context& ui,
			Text&& text,
			Texture&& box
	):
		Button {ui, std::move(text),
			std::make_shared<const Texture>(std::move(box))}
	{}

	Button::Button(
			const Context& ui,
			Text&& text
	):
		Button {ui, std::move(text), ui.button_box(text.size())}
	{}

	Button::Button(
			const Context& ui,
			std::string text
	):
		Button {ui, ui.button_text(text)}
	{}

	void
	Button::disable()
	{ clickable(false); }

	void
	Button::enable()
	{ clickable(true); }

	void
	Button::render(util::Point offset) const
	{
		offset += position();
		if (clickable()) {
			if (held_down())
				offset += m_click_dent;
			m_box->render(offset);
		}
		m_text.render(offset);
	}
}
