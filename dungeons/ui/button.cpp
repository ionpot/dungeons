#include "button.hpp"

#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/text_box.hpp>

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
		widget::TextBox {
			std::make_shared<Text>(std::move(text)),
			box
		},
		m_click_dent {ui.button.click_dent}
	{
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
	{ clickable(false); half_transparent(); }

	void
	Button::enable()
	{ clickable(true); opaque(); }

	void
	Button::render(util::Point offset) const
	{
		if (clickable()) {
			if (held_down())
				offset += m_click_dent;
		}
		widget::TextBox::render(offset);
	}
}
