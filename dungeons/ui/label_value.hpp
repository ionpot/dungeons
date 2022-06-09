#pragma once

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/label_value.hpp>

#include <vector>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	using LabelValue = widget::LabelValue<Text, Text>;

	void align_labels(const Context&, std::vector<LabelValue*>&);
	void stack_labels(const Context&, std::vector<LabelValue*>&);
}
