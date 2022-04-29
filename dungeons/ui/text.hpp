#pragma once

#include "context.hpp"
#include "texture.hpp"

#include <ionpot/widget/padded.hpp>

#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	using Text = Texture;
	using PaddedText = widget::Padded<Text>;

	Text normal_text(const Context&, std::string);
	Text bold_text(const Context&, std::string);
}
