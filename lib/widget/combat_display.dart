import "package:dungeons/game/party.dart";
import "package:dungeons/game/text.dart";
import "package:flutter/widgets.dart";

List<Widget> getXpGainLines(PartyXpGain xpGain) {
  return [
    for (final member in xpGain)
      Text(xpGainText(member.entity, xpGain.amount(member))),
  ];
}
