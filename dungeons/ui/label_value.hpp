#pragma once

#include "context.hpp"
#include "text.hpp"

#include <ionpot/widget/label_value.hpp>

#include <ionpot/util/stringify.hpp>
#include <ionpot/util/vector.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	using LabelValueDef = widget::LabelValue<Text, Text>;

	class LabelValue : public LabelValueDef {
	public:
		LabelValue(std::shared_ptr<const Context>, std::string);

		template<class T>
		void value(T val)
		{ value(util::stringify(val)); }

		template<>
		void value(std::string);

	private:
		std::shared_ptr<const Context> m_ui;
	};

	using LabelValues = util::PtrVector<LabelValue>;

	void align_labels(const Context&, LabelValues&);
	void stack_labels(const Context&, LabelValues&);
	void stack_labels(const Context&, LabelValues&&);
}
