#include "button.hpp"

#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/padding.hpp>
#include <ionpot/widget/text_box.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <string>
#include <utility> // std::move

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	Button::Button(
			const Context& ui,
			std::shared_ptr<Text> text,
			std::shared_ptr<Texture> box
	):
		Parent {
			ui.button.click_dent,
			widget::TextBox {text, box}
		}
	{
		center_text();
		enable();
	}

	Button::Button(
			const Context& ui,
			Text&& text,
			std::shared_ptr<Texture> box
	):
		Button {ui, std::make_shared<Text>(std::move(text)), box}
	{}

	Button::Button(
			const Context& ui,
			Text&& text,
			Texture&& box
	):
		Button {ui, std::move(text),
			std::make_shared<Texture>(std::move(box))}
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
		Button {ui, text, ui.button_text_size(text)}
	{}

	Button::Button(
			const Context& ui,
			std::string text,
			util::Size content_size
	):
		Button {ui, ui.button_text(text), ui.button_box(content_size)}
	{}

	void
	Button::disable()
	{ clickable(false); half_transparent(); }

	void
	Button::enable()
	{ clickable(true); opaque(); }

	void
	Button::left_align_text(const Context& ui)
	{ left_align_text(ui.button.padding); }

	void
	Button::left_align_text(widget::Padding p)
	{ widget::TextBox::left_align_text(p); }

	// TwoStateButton
	// static
	TwoStateButton::BoxPtr
	TwoStateButton::make_active_box(
			const Context& ui,
			util::Size box_size)
	{
		return std::make_shared<Texture>(
			ui.active_button_box(box_size));
	}

	TwoStateButton::BoxPtr
	TwoStateButton::make_normal_box(
			const Context& ui,
			util::Size box_size)
	{
		return std::make_shared<Texture>(
			ui.button_box(box_size));
	}

	TwoStateButton::TextBoxPtr
	TwoStateButton::make_active(
			const Context& ui,
			std::string text,
			BoxPtr box_ptr)
	{
		auto text_ptr = std::make_shared<Texture>(
			ui.active_text(text));
		return std::make_shared<widget::TextBox>(
			text_ptr, box_ptr);
	}

	TwoStateButton::TextBoxPtr
	TwoStateButton::make_normal(
			const Context& ui,
			std::string text,
			BoxPtr box_ptr)
	{
		auto text_ptr = std::make_shared<Texture>(
			ui.button_text(text));
		return std::make_shared<widget::TextBox>(
			text_ptr, box_ptr);
	}

	// constructor
	TwoStateButton::TwoStateButton(
			const Context& ui,
			TextBoxPtr active,
			TextBoxPtr normal
	):
		Parent {ui.button.click_dent},
		m_active {active},
		m_normal {normal}
	{
		clickable(true);
		children({m_active, m_normal});
		update_size();
		this->normal();
	}

	void
	TwoStateButton::active()
	{
		m_normal->hide();
		m_active->show();
	}

	void
	TwoStateButton::center_text()
	{
		m_normal->center_text();
		m_active->center_text();
	}

	void
	TwoStateButton::left_align_text(const Context& ui)
	{ left_align_text(ui.button.padding); }

	void
	TwoStateButton::left_align_text(widget::Padding p)
	{
		m_normal->left_align_text(p);
		m_active->left_align_text(p);
	}

	void
	TwoStateButton::normal()
	{
		m_active->hide();
		m_normal->show();
	}
}
