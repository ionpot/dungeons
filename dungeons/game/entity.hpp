#pragma once

#include "class.hpp"

#include <ionpot/util/percent.hpp>
#include <ionpot/util/scale.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Entity {
	public:
		struct Armor {
			using Ptr = std::shared_ptr<const Armor>;
			enum class Id { leather, scale_mail } id;
			int value {0};
			int initiative {0};
			util::Scale dodge_scale;
		};

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

		Entity(Class::Template::Ptr, int base_armor = 0);

		void base_attr(BaseAttributes);

		const Class& get_class() const;
		void class_template(Class::Template::Ptr);

		int strength() const;
		int agility() const;
		int intellect() const;

		int armor() const;
		void armor(Armor::Ptr);

		int initiative() const;
		int total_hp() const;

		util::Percent dodge_chance() const;
		util::Percent resist_chance() const;

	private:
		BaseAttributes m_base;
		Class m_class;
		Armor::Ptr m_armor;
		int m_base_armor;
	};
}
