#pragma once

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/side_by_side.hpp>
#include <ionpot/widget/stack_down.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <string>
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class Button : public widget::Element {
	public:
		Button(
			const Context&,
			Text&& text,
			std::shared_ptr<const Text> box);

		Button(
			const Context&,
			Text&& text,
			Text&& box);

		Button(
			const Context&,
			Text&& text);

		Button(
			const Context&,
			std::string text);

		void disable();
		void enable();

		void render(util::Point offset = {}) const final;

	private:
		Text m_text;
		std::shared_ptr<const Text> m_box;
		util::Point m_click_dent;
	};

	Text button_box(const Context&, util::Size content_size);
	Text button_text(const Context&, std::string content);

	util::Size button_size(const Context&, util::Size content_size);

	template<class T> // T = widget::Box*
	void
	lay_buttons(const Context& ui, std::vector<T>& buttons)
	{ widget::side_by_side(buttons, ui.button.spacing); }

	template<class T> // T = widget::Box*
	void
	stack_buttons(const Context& ui, std::vector<T>& buttons)
	{ widget::stack_down(buttons, ui.button.spacing); }
}
