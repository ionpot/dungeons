#pragma once

#include "attributes.hpp"
#include "class.hpp"

#include <ionpot/util/percent.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Entity {
	public:
		Entity(Class::TemplatePtr, int base_armor);

		const Attributes& attributes() const;
		void attributes(Attributes);

		const Class& get_class() const;
		void class_template(Class::TemplatePtr);

		int armor() const;
		int initiative() const;
		int total_hp() const;

		util::Percent dodge_chance() const;
		util::Percent resist_chance() const;

	private:
		Attributes m_attr;
		Class m_class;
		int m_armor;
	};
}
