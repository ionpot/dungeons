#pragma once

#include "context.hpp"
#include "radio_group.hpp"

#include <game/class.hpp>
#include <game/context.hpp>

namespace dungeons::ui {
	using ClassSelect = RadioGroup<game::Class::TemplatePtr>;

	ClassSelect class_select(const Context&, const game::Context&);
}
