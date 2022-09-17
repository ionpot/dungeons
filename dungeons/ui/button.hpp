#pragma once

#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/click_dent.hpp>
#include <ionpot/widget/element.hpp>
#include <ionpot/widget/padding.hpp>
#include <ionpot/widget/texture.hpp>
#include <ionpot/widget/text_box.hpp>

#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	struct Button : public widget::ClickDent<widget::TextBox> {
		using Parent = widget::ClickDent<widget::TextBox>;

		Button(
			const Context&,
			std::shared_ptr<Text> text,
			std::shared_ptr<Texture> box);

		Button(
			const Context&,
			Text&& text,
			std::shared_ptr<Texture> box);

		Button(
			const Context&,
			Text&& text,
			Texture&& box);

		Button(
			const Context&,
			Text&& text);

		Button(
			const Context&,
			std::string text);

		Button(
			const Context&,
			std::string text,
			util::Size content_size);

		void disable();
		void enable();

		void left_align_text(const Context&) const;
		void left_align_text(widget::Padding) const;
	};

	template<class T>
	class ButtonWithValue : public Button {
	public:
		ButtonWithValue(
				const Context& ui,
				std::string text,
				util::Size content_size,
				T value
		):
			Button {ui, text, content_size},
			m_value {value}
		{}

		T
		value() const
		{ return m_value; }

	private:
		T m_value;
	};

	class TwoStateButton : public widget::ClickDent<> {
	public:
		using Parent = widget::ClickDent<>;
		using BoxPtr = std::shared_ptr<Texture>;
		using TextBoxPtr = std::shared_ptr<widget::TextBox>;

		static BoxPtr make_active_box(const Context&, util::Size);
		static BoxPtr make_normal_box(const Context&, util::Size);
		static TextBoxPtr make_active(const Context&, std::string, BoxPtr);
		static TextBoxPtr make_normal(const Context&, std::string, BoxPtr);

		TwoStateButton(
			const Context&,
			TextBoxPtr active,
			TextBoxPtr normal);

		void active() const;
		void normal() const;

		void center_text() const;
		void left_align_text(const Context&) const;
		void left_align_text(widget::Padding) const;

	private:
		TextBoxPtr m_active;
		TextBoxPtr m_normal;
	};

	template<class T>
	class TwoStateButtonWithValue : public TwoStateButton {
	public:
		TwoStateButtonWithValue(
				const Context& ui,
				TextBoxPtr active,
				TextBoxPtr normal,
				T value
		):
			TwoStateButton {ui, active, normal},
			m_value {value}
		{}

		T
		value() const
		{ return m_value; }

	private:
		T m_value;
	};
}
