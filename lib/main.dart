import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'game_logic.dart';

void main() {
  gameLogic.makeDeck();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView.builder(
          itemCount: gameLogic.deck.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 8.0,
              ),
              child: gameLogic.deck[index].showCard(),
            );
          },
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
