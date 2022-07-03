#pragma once

#include <ionpot/widget/border.hpp>
#include <ionpot/widget/padding.hpp>

#include <ionpot/sdl/font.hpp>

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/point.hpp>
#include <ionpot/util/rgb.hpp>
#include <ionpot/util/size.hpp>

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	class Config {
	public:
		struct Button {
			util::RGB bg_color;
			widget::Border border;
			util::Point click_dent;
			widget::Padding padding;
			int spacing;
		};

		Config(util::CfgFile&&);

		widget::Border active_border() const;
		util::RGB active_color() const;
		Button button() const;
		sdl::Font::Config font() const;
		util::Point screen_margin() const;
		util::Size section_spacing() const;
		util::RGB text_color() const;
		util::Size text_spacing() const;
		util::Size window_size() const;

	private:
		util::CfgFile m_file;
	};
}
