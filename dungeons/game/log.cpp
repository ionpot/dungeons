#include "log.hpp"

#include "entity.hpp"
#include "string.hpp"

namespace dungeons::game {
	void
	Log::entity(const Entity& e)
	{
		kv(string::class_id(e), string::primary_attr(e));
		put(string::secondary_attr(e));
		kv("Armor", string::armor(e));
		kv("Damage", string::weapon(e));
	}
}
