import 'package:test/test.dart';

import 'package:blackjack_app/game_logic.dart';

final logicTest = GameLogic();

void main(List<String> args) {
  test('check makeDeck is 52 cards', () {
    logicTest.makeDeck();
    expect(logicTest.deck.length, 52);
  });
}
