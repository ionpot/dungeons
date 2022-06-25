#include "label_value.hpp"

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/element.hpp>
#include <ionpot/widget/label_value.hpp>

#include <memory> // std::make_shared, std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	LabelValue::LabelValue(
			std::shared_ptr<const Context> ui,
			std::string label
	):
		widget::LabelValue {
			std::make_shared<Text>(normal_text(*ui, label)),
			std::make_shared<widget::Element>()
		},
		m_ui {ui}
	{}

	template<>
	void
	LabelValue::value(std::string str)
	{
		widget::LabelValue::value(
			std::make_shared<Text>(bold_text(*m_ui, str))
		);
	}

	// helpers
	void
	align_labels(
			const Context& ui,
			const LabelValue::Vector& labels)
	{ widget::align_labels(labels, ui.text_spacing); }

	void
	stack_labels(const Context& ui, const LabelValue::Vector& labels)
	{
		align_labels(ui, labels);
		stack_text(ui, labels);
	}

	void
	stack_labels(const Context& ui, LabelValue::Vector&& labels)
	{ stack_labels(ui, labels); }
}
