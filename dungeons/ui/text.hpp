#pragma once

#include "context.hpp"
#include "texture.hpp"

#include <ionpot/widget/padded.hpp>
#include <ionpot/widget/stack_down.hpp>

#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	using Text = Texture;
	using PaddedText = widget::Padded<Text>;

	Text normal_text(const Context&, int);
	Text normal_text(const Context&, std::string);
	Text bold_text(const Context&, int);
	Text bold_text(const Context&, std::string);

	template<class T> // T = widget::Box*[]
	void
	stack_text(const Context& ui, T& boxes)
	{ widget::stack_down(boxes, ui.text_spacing); }
}
