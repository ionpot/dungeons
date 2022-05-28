#include "label_value.hpp"

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/label_value.hpp>

#include <vector>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	void
	align_labels(
			const Context& ui,
			std::vector<LabelValue*>& labels)
	{ widget::align_labels(labels, ui.text_spacing); }
}
