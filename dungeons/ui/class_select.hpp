#pragma once

#include "context.hpp"
#include "radio_group.hpp"

#include <game/class.hpp>
#include <game/config.hpp>

namespace dungeons::ui {
	struct ClassSelect : public RadioGroup<game::Class::Template::Ptr> {
		using Parent = RadioGroup<game::Class::Template::Ptr>;
		ClassSelect(const Context&, const game::Config::ClassTemplates&);
	};
}
