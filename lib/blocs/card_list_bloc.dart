import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/card_model.dart';
import 'dart:convert';
import '../helpers/card_colors.dart';

class CardListBloc{
  BehaviorSubject<List<CardResults>> _cardCollection = BehaviorSubject<List<CardResults>>();

  List<CardResults> _cardResults;

  //Retrieve Data from Stream
  Stream<List<CardResults>> get cardList => _cardCollection.stream;

  void initialData() async {
    var initialData = await rootBundle.loadString('data/initialData.json');
    var decodedJson = jsonDecode(initialData);
    _cardResults = CardModel.fromJson(decodedJson).results;

    for (var i = 0; i < _cardResults.length; ++i){
      _cardResults[i].cardColor = CardColor.baseColors[i];
    }

    _cardCollection.sink.add(_cardResults);
  }

  CardListBloc(){
    initialData();
  }

  void addCardToList(CardResults newCard){
    _cardResults.add(newCard);
    _cardCollection.sink.add(_cardResults);
  }

  void dispose(){
    _cardCollection.close();
  }
}

final cardListBloc = CardListBloc();