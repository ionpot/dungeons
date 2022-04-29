#pragma once

#include "screen.hpp"

#include <ui/context.hpp>

#include <ionpot/sdl/base.hpp>
#include <ionpot/sdl/events.hpp>

#include <ionpot/util/log.hpp>
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
			std::shared_ptr<const ui::Context>);

		void next(const screen::Output&) const;
		void loop() const;

		template<class T> // T requires:
		// std::optional<screen::Output> handle(const sdl::Event&)
		// void render()
		// void update()
		void
		loop(T&& screen) const
		{
			while (true) {
				auto event = m_events->poll();
				if (event) {
					if (event->quit()) {
						return;
					}
					if (auto output = screen.handle(*event)) {
						return next(*output);
					}
				}
				else {
					screen.update();
					const auto& renderer = *m_ui->renderer;
					renderer.set_color(util::RGB::black);
					renderer.clear();
					screen.render();
					renderer.present();
					m_base->delay(1000 / 30);
				}
			}
		}

	private:
		std::shared_ptr<util::Log> m_log;
		std::shared_ptr<const sdl::Base> m_base;
		std::shared_ptr<const sdl::Events> m_events;
		std::shared_ptr<const ui::Context> m_ui;
	};
}
