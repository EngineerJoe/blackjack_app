import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'game_logic.dart';

void main() {
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
              // Text(gameLogic.dealerTotal.toString()),
              CardHand(cards: gameLogic.dealersCards),
              Text(gameLogic.playerTotal.toString()),
              CardHand(cards: gameLogic.playersCards),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameLogic.setupGame();
                      });
                    },
                    child: Text('Setup Game'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameLogic.dealPlayerCard();
                      });
                    },
                    child: Text('Draw Card'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gameLogic.dealerTurn();
                      });
                    },
                    child: Text('Stay'),
                  ),
                ],
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
