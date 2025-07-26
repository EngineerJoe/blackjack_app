import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:playing_cards/playing_cards.dart';

class UpdatedCard extends PlayingCard {
  UpdatedCard(super.suit, super.value);
  bool isFaceDown = false;

  PlayingCardView showCard() {
    return PlayingCardView(
      card: PlayingCard(suit, value),
      showBack: isFaceDown,
      elevation: 3.0,
    );
  }

  int cardValue() {
    switch (value) {
      case CardValue.ace:
        return 1;
      case CardValue.two:
        return 2;
      case CardValue.three:
        return 3;
      case CardValue.four:
        return 4;
      case CardValue.five:
        return 5;
      case CardValue.six:
        return 6;
      case CardValue.seven:
        return 7;
      case CardValue.eight:
        return 8;
      case CardValue.nine:
        return 9;
      case CardValue.ten:
        return 10;
      case CardValue.jack:
        return 10;
      case CardValue.queen:
        return 10;
      case CardValue.king:
        return 10;
      default:
        return 0;
    }
  }
}

class GameLogic {
  final List<UpdatedCard> deck = [];
  final List<UpdatedCard> playersCards = [];
  final List<UpdatedCard> dealersCards = [];
  double dealerTotal = 0;
  double playerTotal = 0;
  int pot = 0;
  int bank = 500;
  bool gameActive = false;
  String gameMessage = '';

  void resetGame() {
    emptyPot();
    bank = 500;
    gameActive = false;
    emptyHands();
  }

  void makeDeck() {
    for (var suit in Suit.values) {
      for (var value in CardValue.values) {
        deck.add(UpdatedCard(suit, value));
      }
    }
    deck.removeWhere(
      (card) =>
          card.value == CardValue.joker_1 ||
          card.value == CardValue.joker_2 ||
          card.suit == Suit.joker,
    );
    shuffleDeck();
  }

  void shuffleDeck() {
    deck.shuffle();
  }

  List<Widget> displayDeck() {
    List<Widget> fullDeck = [];
    for (var card in deck) {
      fullDeck.add(SizedBox(height: 100, width: 100, child: card.showCard()));
    }
    return fullDeck;
  }

  UpdatedCard drawCard() {
    var card = deck.removeAt(0);
    return card;
  }

  void calculateTotals() {
    playerTotal = 0;
    for (var card in playersCards) {
      playerTotal += card.cardValue();
    }
    for (var card in playersCards) {
      if (card.value == CardValue.ace && playerTotal <= 11) {
        playerTotal += 10;
      }
    }
    dealerTotal = 0;
    for (var card in dealersCards) {
      dealerTotal += card.cardValue();
    }
    for (var card in dealersCards) {
      if (card.value == CardValue.ace && dealerTotal <= 11) {
        dealerTotal += 10;
      }
    }
  }

  void dealPlayerCard() {
    playersCards.insert(0, drawCard());
    calculateTotals();
  }

  void dealDealerCard({bool isFaceDown = false}) {
    var card = drawCard();
    card.isFaceDown = isFaceDown;
    dealersCards.insert(0, card);
    calculateTotals();
  }

  void emptyHands() {
    playersCards.clear();
    dealersCards.clear();
    calculateTotals();
  }

  void setupGame() {
    emptyHands();
    makeDeck();
    dealPlayerCard();
    dealDealerCard(isFaceDown: true);
    dealPlayerCard();
    dealDealerCard();
  }

  void dealerTurn() {
    revealDealerCards();
    while (dealerTotal < 17 && dealerTotal < playerTotal) {
      dealDealerCard();
    }
  }

  void revealDealerCards() {
    for (var card in dealersCards) {
      card.isFaceDown = false;
    }
  }

  bool didPlayerWin() {
    if (playerTotal > dealerTotal || isDealerBust()) {
      return true;
    } else {
      return false;
    }
  }

  bool isPlayerBust() {
    if (playerTotal > 21) {
      return true;
    }
    return false;
  }

  bool isDealerBust() {
    if (dealerTotal > 21) {
      return true;
    }
    return false;
  }

  void emptyPot() {
    pot = 0;
  }

  bool potEmpty() {
    if (pot == 0) {
      return true;
    }
    return false;
  }

  void addToPot(int amount) {
    if (bank - amount >= 0) {
      pot += amount;
      bank -= amount;
    }
  }

  void bet() {
    setupGame();
    gameActive = true;
  }

  void hit() {
    dealPlayerCard();
    if (isPlayerBust()) {
      gameActive = false;
      int lostMoney = pot;
      emptyPot();
      gameMessage = 'Bust, you lost £' + lostMoney.toString();
    }
  }

  void stay() {
    gameActive = false;
    if (isBlackjack()) {
      int wonMoney = (pot * 1.5).toInt() + pot;
      bank += wonMoney;
      emptyPot();
      gameMessage = 'BLACKJACK you won £' + wonMoney.toString();
      return;
    }
    dealerTurn();
    if (didPlayerWin()) {
      int wonMoney = (pot * 2);
      emptyPot();
      bank += wonMoney;
      gameMessage = 'You won £' + wonMoney.toString();
    } else {
      int lostMoney = pot;
      emptyPot();
      gameMessage =
          'Dealer: ' +
          dealerTotal.toInt().toString() +
          '\n' +
          'You lost £' +
          lostMoney.toString();
    }
  }

  bool isBlackjack() {
    if (playerTotal == 21 && playersCards.length == 2) {
      return true;
    }
    return false;
  }
}

final GameLogic gameLogic = GameLogic();
