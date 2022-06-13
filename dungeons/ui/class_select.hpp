#pragma once

#include "context.hpp"
#include "radio_group.hpp"

#include <game/class.hpp>
#include <game/context.hpp>

#include <memory> // std::shared_ptr

namespace dungeons::ui {
	using ClassSelect = RadioGroup<game::Class::Template::Ptr>;

	std::shared_ptr<ClassSelect>
		class_select(const Context&, const game::Context&);
}
