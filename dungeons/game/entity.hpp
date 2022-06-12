#pragma once

#include "class.hpp"

#include <ionpot/util/percent.hpp>

namespace dungeons::game {
	namespace util = ionpot::util;

	class Entity {
	public:
		struct BaseAttributes {
			int strength {0};
			int agility {0};
			int intellect {0};

			BaseAttributes() = default;
			BaseAttributes(int str, int agi, int intel);

			int hp() const;
			int initiative() const;
			util::Percent dodge_chance() const;
			util::Percent resist_chance() const;
		};

		Entity(Class::TemplatePtr, int base_armor);

		void base_attr(BaseAttributes);

		const Class& get_class() const;
		void class_template(Class::TemplatePtr);

		int strength() const;
		int agility() const;
		int intellect() const;

		int armor() const;
		int initiative() const;
		int total_hp() const;

		util::Percent dodge_chance() const;
		util::Percent resist_chance() const;

	private:
		BaseAttributes m_base;
		Class m_class;
		int m_armor;
	};
}
