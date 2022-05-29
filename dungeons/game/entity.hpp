#pragma once

#include "attributes.hpp"
#include "class.hpp"
#include "class_id.hpp"
#include "context.hpp"

#include <ionpot/util/percent.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::game {
	namespace util = ionpot::util;

	class Entity {
	public:
		Entity(std::shared_ptr<const Context>);

		const Attributes& attributes() const;
		void attributes(Attributes);

		ClassId class_id() const;
		void class_id(ClassId);

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
