import "package:dungeons/game/combat.dart";
import "package:dungeons/game/combat/grid.dart";
import "package:dungeons/game/combat/party.dart";
import "package:dungeons/game/entity.dart";
import "package:dungeons/game/entity/class.dart";
import "package:dungeons/game/entity/race.dart";
import "package:dungeons/game/entity/weapon.dart";
import "package:dungeons/game/entity/status_effect.dart";
import "package:dungeons/game/combat/weapon_attack.dart";
import "package:dungeons/game/combat/chance_roll.dart";
import "package:dungeons/game/entity/bonus.dart";
import "package:dungeons/utility/monoids.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("auras are correctly applied and removed", () {
    final t1 = Entity(name: "T1", race: EntityRace.human)..level = 1..klass = EntityClass.warrior;
    t1.gear.offHand = Weapon.torch; // gives Aura.torch to enemies
    final t2 = Entity(name: "T2", race: EntityRace.human)..level = 1..klass = EntityClass.warrior;
    t2.gear.offHand = Weapon.torch; // gives Aura.torch to enemies
    final p = Entity(name: "Player", race: EntityRace.human)..level = 1..klass = EntityClass.warrior;
    
    final enemy = Entity(name: "Enemy", race: EntityRace.orc)..level = 1..klass = EntityClass.warrior;
    enemy.gear.mainHand = Weapon.longsword;
    
    final combat = Combat.fromGrid(CombatGrid(
      player: Party({
        const PartyPosition(PartyLine.front, PartySlot.top): p,
        const PartyPosition(PartyLine.front, PartySlot.center): t1,
        const PartyPosition(PartyLine.front, PartySlot.bottom): t2,
      }),
      enemy: Party.single(enemy),
    ));
    
    // Start combat to apply auras
    for (final event in combat.start()) {
      combat.applyEvent(event);
    }
    
    // Enemy should have the slow aura from the torches
    expect(enemy.auraEffects.has(StatusEffect.slow), isTrue, reason: "Enemy should have slow from torch");
    
    // Enemy attacks T1 and kills T1
    final killInput = WeaponAttackInput(actor: enemy, target: t1);
    final killRolls = WeaponAttackRolls(
      attack: ChanceRoll(100), // force hit
      dodge: ChanceRoll(1), // force no dodge
      damage: killInput.rollDamage()..intBonuses.add(OtherBonus.defending, Int(9999)), // force lethal damage
    );
    final killResult = WeaponAttackResult(killInput, killRolls);
    
    for (final event in combat.applyAction(killResult)) {
      combat.applyEvent(event);
    }
    
    expect(t1.dead, isTrue, reason: "T1 should be dead");
    
    // T2 is still alive and has a torch, so Enemy should STILL have the slow aura!
    expect(enemy.auraEffects.has(StatusEffect.slow), isTrue, reason: "Enemy should still have slow because T2 is alive");
  });
}
