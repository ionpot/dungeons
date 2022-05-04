#pragma once

#include "button.hpp"
#include "context.hpp"
#include "label_value.hpp"

#include <ionpot/widget/box.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr
#include <optional>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewAttributes : public widget::Box {
	public:
		using Value = int;

		NewAttributes(std::shared_ptr<const Context>);

		std::optional<Value> on_click(
			const widget::Click&,
			util::Point offset = {});

		void render(util::Point offset = {}) const;

		void update(util::Point offset = {});

	private:
		std::shared_ptr<const Context> m_ui;
		UniqueButton m_roll;
		UniqueButton m_reroll;
		std::optional<Value> m_value;
		LabelValue m_str;
		LabelValue m_agi;
		LabelValue m_int;

		void update_size();
		void update_value();
	};
}
