#include "class.hpp"

#include "class_id.hpp"
#include "context.hpp"

#include <memory> // std::shared_ptr

namespace dungeons::game {
	Class::Class(std::shared_ptr<const Context> game):
		m_game {game},
		m_id {ClassId::warrior},
		m_level {1}
	{}

	ClassId
	Class::id() const
	{ return m_id; }

	void
	Class::id(ClassId id)
	{ m_id = id; }

	int
	Class::hp_bonus() const
	{ return m_level * m_game->hp_multiplier(m_id); }
}
