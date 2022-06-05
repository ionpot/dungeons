#pragma once

#include "context.hpp"
#include "texture.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/side_by_side.hpp>

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
			Texture&& text,
			std::shared_ptr<const Texture> box);

		Button(
			const Context&,
			Texture&& text,
			Texture&& box);

		Button(
			const Context&,
			Texture&& text);

		Button(
			const Context&,
			std::string text);

		void disable();
		void enable();

		void render(util::Point offset = {}) const;

	private:
		Texture m_text;
		std::shared_ptr<const Texture> m_box;
		util::Point m_click_dent;
	};

	Texture button_box(const Context&, util::Size content_size);
	Texture button_text(const Context&, std::string content);

	util::Size button_size(const Context&, util::Size content_size);

	template<class T> // T = widget::Box*
	void
	lay_buttons(const Context& ui, std::vector<T>& buttons)
	{ widget::side_by_side(buttons, ui.button.spacing); }
}
