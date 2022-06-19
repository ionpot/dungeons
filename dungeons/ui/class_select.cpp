#include "class_select.hpp"

#include "context.hpp"
#include "string.hpp"

#include <game/config.hpp>

#include <memory> // std::make_shared, std::shared_ptr

namespace dungeons::ui {
	std::shared_ptr<ClassSelect>
	class_select(
			const Context& ui,
			const game::Config::ClassTemplates& templates)
	{
		return std::make_shared<ClassSelect>(
			ClassSelect::horizontal(ui, string::class_id, {
				templates.warrior,
				templates.hybrid,
				templates.mage
			})
		);
	}
}
