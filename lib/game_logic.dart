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
    for (var card in dealersCards) {
      card.isFaceDown = false;
    }
    while (dealerTotal < 17) {
      dealDealerCard();
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
}

final GameLogic gameLogic = GameLogic();
