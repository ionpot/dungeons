#pragma once

#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/text_box.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class Button : public widget::TextBox {
	public:
		Button(
			const Context&,
			std::shared_ptr<Text> text,
			std::shared_ptr<const Texture> box);

		Button(
			const Context&,
			Text&& text,
			std::shared_ptr<const Texture> box);

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

		void left_align_text(const Context&);

		void render(util::Point offset = {}) const final;

	private:
		util::Point m_click_dent;
	};
}
