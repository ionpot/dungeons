#pragma once

#include "class_id.hpp"
#include "config.hpp"

namespace dungeons::game {
	class Class {
	public:
		using TemplatePtr = Config::ClassTemplate::Ptr;

		Class(TemplatePtr, int level = 1);

		ClassId id() const;

		int hp_bonus() const;

		void set_template(TemplatePtr);

	private:
		TemplatePtr m_template;
		int m_level;
	};
}
