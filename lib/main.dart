import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'game_logic.dart';

void main() {
  gameLogic.makeDeck();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CardHand(cards: gameLogic.dealersCards),
              CardHand(cards: gameLogic.playersCards),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    gameLogic.dealplayerCard();
                  });
                },
                child: Text('DealCard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardHand extends StatelessWidget {
  CardHand({super.key, required this.cards});
  List<UpdatedCard> cards;
  final List<Widget> hand = [];
  // List<UpdatedCard> cards;

  @override
  Widget build(BuildContext context) {
    for (var card in cards) {
      hand.add(card.showCard());
    }
    return SizedBox(
      width: 150 + ((hand.length - 1) * 30),
      height: 220,
      child: FlatCardFan(children: hand),
    );
  }
}
