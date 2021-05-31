import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'Model.dart';
import 'package:flutter/material.dart';


class ShopingList extends StatefulWidget {
  @override
  _ShopingListState createState() => _ShopingListState();
}

class _ShopingListState extends State<ShopingList> {
  final _saved = <ShopItem>{};
  final _biggerFont = TextStyle(fontSize: 18.0);
  final _databaseInstance = FirebaseDatabase.instance;

  List<ShopItem> _shopingList;

  StreamSubscription<Event> _onShopListAddedSubscription;
  StreamSubscription<Event> _onShopListChangedSubscription;

  Query _shopListQuery;


  @override
  void initState() {
    super.initState();

    _shopingList = <ShopItem>[];
    _shopListQuery = _databaseInstance
      .reference()
      .child('ShopList')
      .orderByValue();
    
    _onShopListAddedSubscription = _shopListQuery.onChildAdded.listen(onEntryAdded);
    _onShopListChangedSubscription = _shopListQuery.onChildChanged.listen(onEntryChanged);
  }

  @override
  void dispose() {
    _onShopListAddedSubscription.cancel();
    _onShopListChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _shopingList.singleWhere((element) {
      return element.title == event.snapshot.key;
    });

    setState(() {
      _shopingList[_shopingList.indexOf(oldEntry)] = ShopItem.fromSnapShot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _shopingList.add(ShopItem.fromSnapShot(event.snapshot));
    });
  }

  updateShopList(ShopItem item) {

    if (item != null) {
      _databaseInstance.reference().child('ShopList').child(item.title).set(item.amount);
    }
  }

  void _addToFridge() {
    _saved.forEach((element) {
      updateShopList(element);
    });
    _saved.clear();
    Navigator.of(context).pop();
  }

  void _pushSaved() {

    Navigator.of(context).push(

      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (ShopItem item) {
              var negIcoBut = new IconButton(
                icon: new Icon(Icons.remove),
                onPressed: () => setState(() => item.amount--));

              var textField = new Text(item.amount.toString());

              var posIcoBut =new IconButton(
                icon: new Icon(Icons.add),
                onPressed: () => setState(() => item.amount++));
            

              return ListTile(
                title: Text(item.title, style: _biggerFont),
                trailing: 
                    Row(
                      children: <Widget>[
                        negIcoBut, Text(item.amount.toString()), posIcoBut
                      ],
                      mainAxisSize: MainAxisSize.min,
                    )

              );
            },
          );

          final divided = tiles.isNotEmpty ? ListTile.divideTiles(context: context, tiles: tiles).toList() : <Widget>[];

          divided.add(showPrimaryButton());

          var indTiles = List.generate(_saved.length, (index) => ListTileItems(
                
                cartItem: _saved.elementAt(index),

              ));

          

          final itrTiles = indTiles.isNotEmpty ? ListTile.divideTiles(context: context, tiles: indTiles).toList() : <Widget>[];
          itrTiles.add(showPrimaryButton());

          return Scaffold(
            appBar: AppBar(
              title: Text('Shopping Cart'),
            ),
            body: ListView(
              children: itrTiles
              ),
            );
          
        },
      )
    );
  }

  Widget showPrimaryButton() {


    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20, color: Colors.white60), onSurface: Colors.blueAccent),
            onPressed: _addToFridge,
            child: const Text('Add to fridge'),
          )
        )
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
        actions: [
          IconButton(icon: Icon(Icons.list),
          onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildShopingList(context, _shopingList)
    );
  }

  Widget _buildShopingList(BuildContext ctx, List<ShopItem> list) {

    return ListView.builder(
      itemCount: list.length * 2,
      itemBuilder: (ctx, index) {

        if (index.isOdd)
          return Divider();
          
        ShopItem listItem = list[(index~/2)];
        return _buildRow(listItem);
      }
    );

  }

  Widget _buildRow(ShopItem item) {
    final isSaved = _saved.contains(item);

    return ListTile(

      title: Text(
        item.title,
        style: _biggerFont,
        ),
      subtitle: Text(item.amount.toString()),
      trailing: Icon(
        isSaved ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
        color: isSaved ? Colors.green : Colors.black,
      ),

      onTap: () {
        setState(() {

          if (isSaved) {
            _saved.remove(item);
          }
          else {
            _saved.add(item);
          }
        });
      },
    );
  }

}

class ListTileItems extends StatefulWidget {
  ShopItem cartItem;

  ListTileItems({this.cartItem});

  @override
  _ListTileItemsState createState() => _ListTileItemsState();
}

class _ListTileItemsState extends State<ListTileItems> {
  int itemCount = 0;

  @override
  Widget build(BuildContext context) {

    return new ListTile(

      title: new Text(widget.cartItem.title),
      trailing: new Row(
        children: <Widget>[
          itemCount != 0 ?

          new IconButton(
            icon: new Icon(Icons.remove),
            onPressed: () => setState(() {
              itemCount--;
              widget.cartItem.amount--;
            }),
          )

          : new Container(), new Text(itemCount.toString()),

          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () => setState(() {
              itemCount++;
              widget.cartItem.amount++;
            })
          )

        ],
        mainAxisSize: MainAxisSize.min,
      ),

    );
  }
}