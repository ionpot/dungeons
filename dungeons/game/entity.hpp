#pragma once

#include "attributes.hpp"
#include "class.hpp"

namespace dungeons::game {
	class Entity {
	public:
		Entity() = default;

		const Attributes& attributes() const;
		void attributes(Attributes);

		Class get_class() const;
		void set_class(Class);

	private:
		Attributes m_attr;
		Class m_class;
	};
}
