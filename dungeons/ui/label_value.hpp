#pragma once

#include "context.hpp"

#include <ionpot/widget/label_value.hpp>

#include <ionpot/util/stringify.hpp>

#include <memory> // std::shared_ptr
#include <string>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class LabelValue : public widget::LabelValue {
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

	void align_labels(const Context&, const LabelValue::Vector&);
	void stack_labels(const Context&, const LabelValue::Vector&);
	void stack_labels(const Context&, LabelValue::Vector&&);
}
