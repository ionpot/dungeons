#pragma once

#include "context.hpp"
#include "radio_group.hpp"

#include <game/class_id.hpp>

namespace dungeons::ui {
	using ClassSelect = RadioGroup<game::ClassId>;

	ClassSelect class_select(const Context&);
}
