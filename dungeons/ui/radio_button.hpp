#pragma once

#include "button.hpp"
#include "context.hpp"
#include "text.hpp"
#include "texture.hpp"

#include <ionpot/widget/element.hpp>

#include <ionpot/util/point.hpp>
#include <ionpot/util/size.hpp>

#include <memory> // std::shared_ptr, std::make_shared
#include <optional>
#include <string>
#include <utility> // std::move
#include <vector>

namespace dungeons::ui {
	namespace util = ionpot::util;
	namespace widget = ionpot::widget;

	template<class T> // T = enum value
	class RadioButton : public widget::Element {
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
			widget::Element {button.size()},
			m_button {std::move(button)},
			m_chosen {std::move(chosen)},
			m_value {value}
		{
			m_chosen.hide();
		}

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

		widget::Element*
		find(util::Point point, util::Point offset = {})
		{
			if (contains(m_button, point, offset))
				return &m_button;
			return nullptr;
		}

		bool
		is_click(const widget::Element& clicked) const
		{ return m_button == clicked; }

		void
		render(util::Point offset = {}) const
		{
			widget::Element::render(m_button, offset);
			widget::Element::render(m_chosen, offset);
		}

		void
		set()
		{
			m_chosen.show();
			m_button.hide();
		}

		void
		reset()
		{
			m_chosen.hide();
			m_button.show();
		}

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
