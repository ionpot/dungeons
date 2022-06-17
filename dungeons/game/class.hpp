#pragma once

#include <memory> // std::shared_ptr

namespace dungeons::game {
	class Class {
	public:
		enum class Id { warrior, hybrid, mage };

		struct Template {
			using Ptr = std::shared_ptr<const Template>;
			Id id;
			int hp_bonus_per_level;
		};

		Class(Template::Ptr, int level = 1);

		Id id() const;

		int hp_bonus() const;

		void set_template(Template::Ptr);

	private:
		Template::Ptr m_template;
		int m_level;
	};
}
