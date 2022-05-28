#pragma once

#include "class_id.hpp"
#include "context.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	class Class {
	public:
		Class(std::shared_ptr<const Context>);

		ClassId id() const;
		void id(ClassId);

		int hp_bonus() const;

	private:
		std::shared_ptr<const Context> m_game;
		ClassId m_id;
		int m_level;
	};
}
