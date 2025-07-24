import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';
import 'game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  bool gameActive = false;
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  gameLogic.setupGame();
                  gameActive = true;
                });
              },
              child: Text('Setup Game'),
            ),
            ElevatedButton(
              onPressed: gameLogic.isPlayerBust() || !gameActive
                  ? null
                  : () {
                      setState(() {
                        gameLogic.dealPlayerCard();
                        if (gameLogic.isPlayerBust()) {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'Bust!',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      });
                    },
              child: Text('Draw Card'),
            ),
            ElevatedButton(
              onPressed: gameLogic.isPlayerBust() || !gameActive
                  ? null
                  : () {
                      gameActive = false;
                      setState(() {
                        gameLogic.dealerTurn();
                        if (gameLogic.didPlayerWin()) {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'You WIN!',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'You Lost',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      });
                    },
              child: Text('Stay'),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(gameLogic.dealerTotal.toString()),
            CardHand(cards: gameLogic.dealersCards),
            Text(gameLogic.playerTotal.toInt().toString()),
            CardHand(cards: gameLogic.playersCards),
          ],
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
