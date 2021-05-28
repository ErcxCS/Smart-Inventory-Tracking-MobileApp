import 'Networking.dart';
import 'package:flutter/material.dart';

class ShopingList extends StatefulWidget {
  @override
  _ShopingListState createState() => _ShopingListState();
}

class _ShopingListState extends State<ShopingList> {
  

  @override
  Widget build(BuildContext context) {
    final _shoppingList = fetchAlbum();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch data exmpel'),
      ),
      body: Center(
        child: FutureBuilder<Album>(
          future: _shoppingList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.title);
            }
            else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return CircularProgressIndicator();
          },
        )
      )
    );
  }
}