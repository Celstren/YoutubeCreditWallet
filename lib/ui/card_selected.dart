import 'package:flutter/material.dart';
import '../ui/widgets/my_appbar.dart';
import '../models/card_model.dart';
import '../blocs/card_list_bloc.dart';

class CardSelected extends StatelessWidget {
  final int indexItemSelected;

  CardSelected({Key key, @required this.indexItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: MyAppBar(
        appBarTitle: 'Edit Card',
        leadingIcon: Icons.arrow_back,
        context: context,
      ),
      backgroundColor: Colors.grey[100],
      body: StreamBuilder<List<CardResults>>(
        stream: cardListBloc.cardList,
        builder: (context, snapshot) {
          return Wrap(
            children: <Widget>[
              !snapshot.hasData
                  ? CircularProgressIndicator()
                  : Wrap(
                      children: <Widget>[
                        SizedBox(
                          height: _screenSize.height * 0.4,
                          child: CardFrontList(
                            cardModel: snapshot.data[indexItemSelected],
                          ),
                        ),
                        SizedBox(
                          height: _screenSize.height * 0.05,
                        ),
                        SizedBox(
                          child: CardEditField(
                            cardModel: snapshot.data[indexItemSelected],
                          ),
                        )
                      ],
                    )
            ],
          );
        },
      ),
    );
  }
}

class CardFrontList extends StatelessWidget {
  final CardResults cardModel;
  CardFrontList({this.cardModel});

  @override
  Widget build(BuildContext context) {
    final _cardLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 25.0, right: 52.0),
          child: Image(
            image: AssetImage('assets/visa_logo.png'),
            width: 65.0,
            height: 32.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 52.0),
          child: Text(
            cardModel.cardType,
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );

    final _cardNumber = Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildDots(),
        ],
      ),
    );

    final _cardLastNumber = Padding(
      padding: const EdgeInsets.only(top: 1.0, left: 55.0),
      child: Text(
        cardModel.cardNumber.substring(12),
        style: TextStyle(color: Colors.white, fontSize: 8.0),
      ),
    );

    final _cardValidThru = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  'valid',
                  style: TextStyle(color: Colors.white, fontSize: 8.0),
                ),
                Text(
                  'thru',
                  style: TextStyle(color: Colors.white, fontSize: 8.0),
                ),
              ],
            ),
            SizedBox(
              width: 5.0,
            ),
            Text(
              '${cardModel.cardMonth}/${cardModel.cardYear.substring(2)}',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ));

    final _cardOwner = Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 50.0),
      child: Text(
        cardModel.cardHolderName,
        style: TextStyle(color: Colors.white, fontSize: 18.0),
      ),
    );

    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: cardModel.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _cardLogo,
            //CardChip(),
            _cardNumber,
            _cardLastNumber,
            _cardValidThru,
            _cardOwner,
          ],
        ));
  }

  Widget _buildDots() {
    List<Widget> dotList = new List<Widget>();
    var counter = 0;
    for (var i = 0; i < 12; i++) {
      counter += 1;
      dotList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3.0),
          child: Container(
            width: 6.0,
            height: 6.0,
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
      if (counter == 4) {
        counter = 0;
        dotList.add(SizedBox(width: 30.0));
      }
    }
    dotList.add(_buildNumbers());
    return Row(children: dotList);
  }

  Widget _buildNumbers() {
    return Text(
      cardModel.cardNumber.substring(12),
      style: TextStyle(color: Colors.white),
    );
  }
}

class CardEditField extends StatelessWidget {
  final CardResults cardModel;
  CardEditField({this.cardModel});

  @override
  Widget build(BuildContext context) {
    final _cardOwner = TextField(
      textCapitalization: TextCapitalization.characters,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white,
        hintText: cardModel.cardHolderName,
      ),
    );

    return Container(
      child: Wrap(
        children: <Widget>[_cardOwner],
      ),
    );
  }
}
