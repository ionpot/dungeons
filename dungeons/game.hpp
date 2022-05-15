#pragma once

#include "mouse.hpp"
#include "screen.hpp"

#include <ui/context.hpp>

#include <game/context.hpp>

#include <ionpot/sdl/base.hpp>
#include <ionpot/sdl/events.hpp>

#include <ionpot/util/log.hpp>
#include <ionpot/util/point.hpp>
#include <ionpot/util/rgb.hpp>

#include <memory> // std::shared_ptr

namespace dungeons {
	namespace sdl = ionpot::sdl;
	namespace util = ionpot::util;

	class Game {
	public:
		Game(
			std::shared_ptr<util::Log>,
			std::shared_ptr<const sdl::Base>,
			std::shared_ptr<const sdl::Events>,
			std::shared_ptr<const ui::Context>,
			std::shared_ptr<game::Context>,
			Mouse&&);

		void next(const screen::Output&);
		void loop();

		template<class T> // T requires:
		// widget::Element* find(util::Point)
		// std::optional<screen::Output> on_click(const widget::Element&)
		// void render() const
		void
		loop(T&& screen)
		{
			check_hovered(screen, m_mouse.position());
			while (true) {
				if (auto event = m_events->poll()) {
					if (event->quit())
						return;
					if (event->key_up())
						return;
					if (auto pos = event->lmb_down()) {
						m_mouse.lmb_down(screen.find(*pos));
						continue;
					}
					if (auto pos = event->lmb_up()) {
						auto elmt = screen.find(*pos);
						if (m_mouse.lmb_up(elmt) && elmt) {
							if (auto output = screen.on_click(*elmt))
								return next(*output);
							check_hovered(screen, pos);
						}
						continue;
					}
					continue;
				}
				check_hovered(screen, m_mouse.moved());
				const auto& renderer = *m_ui->renderer;
				renderer.set_color(util::RGB::black);
				renderer.clear();
				screen.render();
				renderer.present();
				m_base->delay(1000 / 30);
			}
		}

	private:
		std::shared_ptr<util::Log> m_log;
		std::shared_ptr<const sdl::Base> m_base;
		std::shared_ptr<const sdl::Events> m_events;
		std::shared_ptr<const ui::Context> m_ui;
		std::shared_ptr<game::Context> m_game;
		Mouse m_mouse;

		template<class T> // T requires:
		// widget::Element* find(util::Point)
		void
		check_hovered(T& screen, std::optional<util::Point> cursor_pos)
		{
			if (cursor_pos)
				m_mouse.hovered(screen.find(*cursor_pos));
		}
	};
}
