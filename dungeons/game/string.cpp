#include "string.hpp"

#include "class.hpp"
#include "combat.hpp"
#include "entity.hpp"

#include <ionpot/util/percent_roll.hpp>
#include <ionpot/util/string.hpp>

#include <string>

namespace dungeons::game::string {
	namespace util = ionpot::util;

	namespace {
		auto parens = util::string::parens;
	}

	std::string
	armor(Entity::Armor::Id id)
	{
		switch (id) {
		case Entity::Armor::Id::leather:
			return "Leather";
		case Entity::Armor::Id::scale_mail:
			return "Scale Mail";
		}
	}

	std::string
	armor(Entity::Armor::Ptr a)
	{
		return a
			? armor(a->id)
			: "No Armor";
	}

	std::string
	armor(const Entity& e)
	{
		return std::to_string(e.total_armor()) + " "
			+ parens(armor(e.armor));
	}

	Lines
	attack(const Combat::Attack& atk)
	{
		Lines lines;
		lines.push_back(weapon_attack(atk));
		lines.push_back("Hit chance " + percent_roll(atk.hit_roll));
		if (auto dodge = atk.dodge_roll)
			lines.push_back("Dodge chance " + percent_roll(*dodge));
		lines.push_back(attack_result(atk));
		return lines;
	}

	std::string
	attack_result(const Combat::Attack& atk)
	{
		using Result = Combat::Attack::Result;
		auto name = atk.defender->name;
		switch (atk.result) {
		case Result::deflected:
			return name + " deflects the attack.";
		case Result::dodged:
			return name + " dodges the attack.";
		case Result::hit:
			return takes_damage(*atk.defender, atk.damage);
		}
	}

	std::string
	class_id(Class::Template::Id id)
	{
		switch (id) {
		case Class::Template::Id::warrior:
			return "Warrior";
		case Class::Template::Id::hybrid:
			return "Hybrid";
		case Class::Template::Id::mage:
			return "Mage";
		}
	}

	std::string
	class_id(Class::Template::Ptr t)
	{ return class_id(t->id); }

	std::string
	class_id(const Entity& e)
	{ return class_id(e.klass.get_template()); }

	std::string
	percent_roll(const util::PercentRoll& roll)
	{
		auto percent = roll.percent.to_str();
		auto success = roll.success() ? "success" : "fail";
		if (roll.result)
			return percent + ": Rolls " + std::to_string(*roll.result)
				+ ", " + success + ".";
		return percent + ": Auto " + success + ".";
	}

	std::string
	primary(const Entity& e)
	{ return race(e) + " " + class_id(e) + ": " + primary_attr(e); }

	std::string
	primary_attr(const Entity& e)
	{
		return "Str " + std::to_string(e.strength())
			+ ", Agi " + std::to_string(e.agility())
			+ ", Int " + std::to_string(e.intellect());
	}

	std::string
	race(Entity::Race::Id id)
	{
		switch (id) {
		case Entity::Race::Id::human:
			return "Human";
		case Entity::Race::Id::orc:
			return "Orc";
		}
	}

	std::string
	race(Entity::Race::Ptr r)
	{ return race(r->id); }

	std::string
	race(const Entity& e)
	{ return race(e.race); }

	std::string
	round(int i)
	{ return "Round " + std::to_string(i); }

	std::string
	secondary_attr(const Entity& e)
	{
		return "Hp " + std::to_string(e.current_hp())
			+ "/" + std::to_string(e.total_hp())
			+ ", Dodge " + e.dodge_chance().to_str()
			+ ", Init " + std::to_string(e.initiative())
			+ ", Resist " + e.resist_chance().to_str();
	}

	std::string
	takes_damage(const Entity& e, int dmg)
	{
		return e.name + " takes " + std::to_string(dmg) + " damage"
			+ (e.dead() ? ", and dies." : ".");
	}

	std::string
	weapon(Entity::Weapon::Id id)
	{
		switch (id) {
		case Entity::Weapon::Id::dagger:
			return "Dagger";
		case Entity::Weapon::Id::halberd:
			return "Halberd";
		case Entity::Weapon::Id::longsword:
			return "Longsword";
		case Entity::Weapon::Id::mace:
			return "Mace";
		}
	}

	std::string
	weapon(Entity::Weapon::Ptr w)
	{
		return w
			? weapon(w->id) + " " + parens(w->dice.to_str())
			: "No Weapon";
	}

	std::string
	weapon(const Entity& e)
	{
		return e.weapon_damage().to_str() + " "
			+ parens(weapon(e.weapon));
	}

	std::string
	weapon_attack(const Combat::Attack& atk)
	{
		return atk.attacker->name
			+ " attacks " + atk.defender->name
			+ " with " + weapon(atk.attacker->weapon->id)
			+ ".";
	}
}
