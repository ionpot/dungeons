import "package:dungeons/game/combat.dart";
import "package:dungeons/game/combat/action_input.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/combat/spell_cast.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/class.dart";
import "package:dungeons/game/entity/race.dart";
import "package:dungeons/game/entity/spell.dart";
import "package:dungeons/game/entity/status_effect.dart";
import "package:dungeons/game/combat/weapon_attack.dart";
import "package:dungeons/game/combat/chance_roll.dart";
import "package:dungeons/game/entity/weapon.dart";
import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/utility/monoids.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("bless interaction", () {
    final a = Entity(name: "A", race: EntityRace.human)..level = 1..klass = EntityClass.cleric;
    final b = Entity(name: "B", race: EntityRace.human)..level = 1..klass = EntityClass.warrior;
    final c = Entity(name: "C", race: EntityRace.human)..level = 1..klass = EntityClass.warrior;
    
    // We need to give C a weapon otherwise weaponDamage is null.
    c.gear.mainHand = Weapon.longsword;
    
    final combat = Combat.fromGrid(CombatGrid(
      player: Party({
        const PartyPosition(PartyLine.front, PartySlot.top): a,
        const PartyPosition(PartyLine.front, PartySlot.bottom): b,
      }),
      enemy: Party.single(c),
    ));
    
    // A casts bless on B
    final input = SpellCastInput(Spell.bless, caster: a, target: b);
    final rolls = SpellCastRolls(resist: ChanceRoll(100)); // force no resist
    final result = SpellCastResult.from(input, rolls);
    
    for (final event in combat.applyAction(result)) {
      combat.applyEvent(event);
    }
    
    expect(b.effects.has(StatusEffect.bless), isTrue);
    expect(a.reservedStress.length, 1);
    
    // Now C attacks A and kills A
    final killInput = WeaponAttackInput(actor: c, target: a);
    final killRolls = WeaponAttackRolls(
      attack: ChanceRoll(100), // force hit
      dodge: ChanceRoll(1), // force no dodge
      damage: killInput.rollDamage()..intBonuses.add(OtherBonus.defending, Int(9999)), // force lethal damage
    );
    final killResult = WeaponAttackResult(killInput, killRolls);
    
    for (final event in combat.applyAction(killResult)) {
      combat.applyEvent(event);
    }
    
    expect(a.dead, isTrue);
    expect(combat.state.reservations.isEmpty, isTrue, reason: "Reservations should be empty when A dies");
    expect(b.effects.has(StatusEffect.bless), isFalse, reason: "B should lose bless effect when A dies");
  });
}
