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
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Blackjack',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 1)),
            Text('Bank: £' + gameLogic.bank.toString()),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 130,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  child: CustomChip(chipColor: Colors.grey, chipValue: 1),
                  onTap: () => {
                    if (!gameActive) {setState(() => gameLogic.addToPot(1))},
                  },
                ),
                GestureDetector(
                  child: CustomChip(chipColor: Colors.red, chipValue: 2),
                  onTap: () => {
                    if (!gameActive) {setState(() => gameLogic.addToPot(2))},
                  },
                ),
                GestureDetector(
                  child: CustomChip(chipColor: Colors.purple, chipValue: 5),
                  onTap: () => {
                    if (!gameActive) {setState(() => gameLogic.addToPot(5))},
                  },
                ),
                GestureDetector(
                  child: CustomChip(chipColor: Colors.blue, chipValue: 10),
                  onTap: () => {
                    if (!gameActive) {setState(() => gameLogic.addToPot(10))},
                  },
                ),
                GestureDetector(
                  child: CustomChip(chipColor: Colors.black, chipValue: 20),
                  onTap: () => {
                    if (!gameActive) {setState(() => gameLogic.addToPot(20))},
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: gameLogic.potEmpty() || gameActive
                      ? null
                      : () {
                          setState(() {
                            gameLogic.setupGame();
                            gameActive = true;
                          });
                        },
                  child: Text('Draw'),
                ),
                ElevatedButton(
                  onPressed: gameLogic.isPlayerBust() || !gameActive
                      ? null
                      : () {
                          setState(() {
                            gameLogic.dealPlayerCard();
                            if (gameLogic.isPlayerBust()) {
                              gameLogic.emptyPot();
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
                              gameLogic.addPotToBankX2();
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
                              gameLogic.emptyPot();
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
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(gameLogic.dealerTotal.toString()),
            // CardCounter(cards: gameLogic.dealerTotal.toInt().toString()),
            CardHand(cards: gameLogic.dealersCards),
            CardCounter(cards: gameLogic.playerTotal.toInt().toString()),
            CardHand(cards: gameLogic.playersCards),
            Padding(padding: EdgeInsetsGeometry.symmetric(vertical: 10)),
            Text(
              'Pot: £' + gameLogic.pot.toString(),
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class CardCounter extends StatelessWidget {
  CardCounter({super.key, required this.cards});
  String cards;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.all(10),
      child: Text(
        cards,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CustomChip extends StatelessWidget {
  CustomChip({super.key, required this.chipColor, required this.chipValue});
  Color chipColor;
  int chipValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 50,
      height: 50,
      decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
      child: Container(
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: Text(
            chipValue.toString(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
