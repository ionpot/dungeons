#include "button.hpp"

#include "context.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/solid_box.hpp>
#include <ionpot/widget/texture.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <string>
#include <utility> // std::move

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	Button::Button(
			const Context& ui,
			widget::Texture&& text,
			std::shared_ptr<const widget::Texture> box
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
			widget::Texture&& text,
			widget::Texture&& box
	):
		Button {ui, std::move(text),
			std::make_shared<const widget::Texture>(std::move(box))}
	{}

	Button::Button(
			const Context& ui,
			widget::Texture&& text
	):
		Button {ui, std::move(text), button_box(ui, text.size())}
	{}

	Button::Button(
			const Context& ui,
			std::string text
	):
		Button {ui, ui.bold_text(text)}
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

	// helpers
	widget::Texture
	button_box(const Context& ui, util::Size content_size)
	{
		return widget::solid_box(
			ui.renderer,
			button_size(ui, content_size),
			ui.button.bg_color,
			ui.button.border
		);
	}

	util::Size
	button_size(const Context& ui, util::Size content_size)
	{ return content_size + ui.button.padding.size(); }

	widget::Texture
	button_text(const Context& ui, std::string content)
	{ return ui.bold_text(content); }
}
