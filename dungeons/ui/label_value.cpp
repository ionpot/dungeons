#include "label_value.hpp"

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/label_value.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	LabelValue::LabelValue(
			std::shared_ptr<const Context> ui,
			std::string label
	):
		LabelValueDef {normal_text(*ui, label)},
		m_ui {ui}
	{}

	template<>
	void
	LabelValue::value(std::string str)
	{ LabelValueDef::value(bold_text(*m_ui, str)); }

	// helpers
	void
	align_labels(
			const Context& ui,
			LabelValues& labels)
	{ widget::align_labels(labels, ui.text_spacing); }

	void
	stack_labels(const Context& ui, LabelValues& labels)
	{
		align_labels(ui, labels);
		stack_text(ui, labels);
	}

	void
	stack_labels(const Context& ui, LabelValues&& labels)
	{ stack_labels(ui, labels); }
}
