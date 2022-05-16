#include "config.hpp"

#include <ionpot/widget/border.hpp>
#include <ionpot/widget/padding.hpp>

#include <ionpot/sdl/font.hpp>

#include <ionpot/util/cfg_file.hpp>
#include <ionpot/util/rgb.hpp>
#include <ionpot/util/size.hpp>

#include <utility> // std::move

namespace dungeons::ui {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	Config::Config(util::CfgFile&& file):
		m_file {std::move(file)}
	{}

	Config::Button
	Config::button() const
	{
		auto section = m_file.find_section("button");
		return {
			section.find_pair("background color").to_rgb(),
			widget::Border {
				section.find_pair("border width").to_int(),
				section.find_pair("border color").to_rgb()
			},
			section.find_pair("click dent").to_point(),
			widget::Padding {
				section.find_pair("padding").to_size()
			},
			section.find_pair("spacing").to_int()
		};
	}

	sdl::Font::Config
	Config::font() const
	{
		return {
			m_file.find_pair("font file").value,
			m_file.find_section("text").find_pair("size").to_int()
		};
	}

	util::RGB
	Config::text_color() const
	{
		return m_file.find_section("text").find_pair("color").to_rgb();
	}

	util::Size
	Config::text_spacing() const
	{
		return m_file.find_section("text").find_pair("spacing").to_size();
	}

	util::Size
	Config::window_size() const
	{
		return m_file.find_pair("window size").to_size();
	}
}
