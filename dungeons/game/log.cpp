#include "log.hpp"

#include "entity.hpp"
#include "string.hpp"

namespace dungeons::game {
	void
	Log::entity(const Entity& e)
	{
		put(e.name);
		put(string::primary(e));
		put(string::secondary_attr(e));
		kv("Armor", string::armor(e));
		kv("Damage", string::weapon_damage(e));
	}
}
