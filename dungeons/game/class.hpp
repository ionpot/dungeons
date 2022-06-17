#pragma once

#include <memory> // std::shared_ptr

namespace dungeons::game {
	class Class {
	public:
		struct Template {
			using Ptr = std::shared_ptr<const Template>;
			enum class Id { warrior, hybrid, mage } id;
			int hp_bonus_per_level;
		};

		Class(Template::Ptr, int level = 1);

		Template::Ptr get_template() const;
		void set_template(Template::Ptr);

		int hp_bonus() const;

	private:
		Template::Ptr m_template;
		int m_level;
	};
}
