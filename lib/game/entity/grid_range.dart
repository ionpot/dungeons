enum PartyRange { ally, enemy }

enum SlotRange { adjacent, any }

enum GridRange {
  melee(PartyRange.enemy, SlotRange.adjacent),
  any(PartyRange.enemy, SlotRange.any),
  ally(PartyRange.ally, SlotRange.any);

  final PartyRange party;
  final SlotRange slot;

  const GridRange(this.party, this.slot);
}
