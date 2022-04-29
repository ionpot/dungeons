#pragma once

#include "context.hpp"
#include "radio_group.hpp"

#include <game/class.hpp>

namespace dungeons::ui {
	using ClassSelect = RadioGroup<game::Class>;

	ClassSelect class_select(const Context&);
}
