#pragma once

#include "button.hpp"
#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/box.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr, std::make_shared
#include <string>
#include <utility> // std::move
#include <vector>

namespace dungeons::ui {
	namespace widget = ionpot::widget;

	template<class T> // T = enum value
	class RadioButton : public widget::Box {
	public:
		struct Input {
			std::string text;
			T value;

			static util::Size
			max_text_size(const Context& ctx, const std::vector<Input>& input)
			{
				util::Size size;
				for (const auto& i : input) {
					size.pick_max(ctx.bold_text_size(i.text));
				}
				return size + ctx.button.padding.size();
			}
		};

		RadioButton(
				SharedButton&& button,
				PaddedText&& chosen,
				T value
		):
			widget::Box {button.size()},
			m_button {std::move(button)},
			m_chosen {std::move(chosen)},
			m_value {value}
		{}

		RadioButton(
				const Context& ctx,
				std::shared_ptr<const Texture> box,
				const Input& input
		):
			RadioButton {
				shared_button(ctx, input.text, box),
				PaddedText {
					bold_text(ctx, input.text),
					box->size()
				},
				input.value
			}
		{}

		void
		render_button(util::Point offset = {}) const
		{ m_button.render(position() + offset); }

		void
		render_chosen(util::Point offset = {}) const
		{ m_chosen.render(position() + offset); }

		void
		reset_cursor() const
		{ m_button.reset_cursor(); }

		void
		update(util::Point offset = {})
		{ m_button.update(position() + offset); }

		T
		value() const
		{ return m_value; }

		static std::vector<RadioButton>
		from(
				const Context& ctx,
				const std::vector<Input>& inputs)
		{
			auto size = Input::max_text_size(ctx, inputs);
			auto box = std::make_shared<const Texture>(
				button_box(ctx, size)
			);
			std::vector<RadioButton> buttons;
			for (const auto& input : inputs) {
				buttons.emplace_back(ctx, box, input);
			}
			return buttons;
		}

	private:
		SharedButton m_button;
		PaddedText m_chosen;
		T m_value;
	};
}
