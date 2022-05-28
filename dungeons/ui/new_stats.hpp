#pragma once

#include "context.hpp"
#include "label_value.hpp"

#include <game/entity.hpp>

#include <ionpot/widget/element.hpp>

#include <ionpot/util/point.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class NewStats : public widget::Element {
	public:
		NewStats(std::shared_ptr<const Context>);

		void render(util::Point offset = {}) const;
		void update(const game::Entity&);

	private:
		std::shared_ptr<const Context> m_ui;
		LabelValue m_hp;
		LabelValue m_dodge;
		LabelValue m_initiative;
		LabelValue m_will;

		void update_size();
	};
}
