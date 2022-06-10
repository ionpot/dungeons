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

	void
	stack_labels(const Context& ui, std::vector<LabelValue*>& labels)
	{
		align_labels(ui, labels);
		stack_text(ui, labels);
	}

	void
	stack_labels(const Context& ui, std::vector<LabelValue*>&& labels)
	{ stack_labels(ui, labels); }
}
