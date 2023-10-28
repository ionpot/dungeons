import 'package:dungeons/game/party.dart';
import 'package:flutter/widgets.dart';

const double topY = 30;
const double bottomY = 516;
const Offset buttonsOffset = Offset(34, bottomY);
const Offset displayOffset = Offset(672, bottomY);
const Offset leftStatsOffset = Offset(30, topY);
const Offset rightStatsOffset = Offset(990, topY);

double playerPartySlotX(PartyLine line) {
  switch (line) {
    case PartyLine.front:
      return 486;
    case PartyLine.back:
      return 342;
  }
}

double enemyPartySlotX(PartyLine line) {
  switch (line) {
    case PartyLine.front:
      return 664;
    case PartyLine.back:
      return 808;
  }
}

double partySlotY(PartySlot slot) {
  switch (slot) {
    case PartySlot.left:
      return 34;
    case PartySlot.center:
      return 180;
    case PartySlot.right:
      return 326;
  }
}

Offset playerPartySlotOffset(PartyPosition position) {
  return Offset(
    playerPartySlotX(position.line),
    partySlotY(position.slot),
  );
}

Offset enemyPartySlotOffset(PartyPosition position) {
  return Offset(
    enemyPartySlotX(position.line),
    partySlotY(position.slot),
  );
}
