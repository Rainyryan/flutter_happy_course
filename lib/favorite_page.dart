import 'package:flutter/material.dart';
import 'rest_model.dart';
import 'rest.dart';
import 'rest_card.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
        //body: RestModel.getFavByIndex(0)
      // body: ListView.builder(
      //         itemCount: RestModel.getFavLen(),
      //         itemBuilder: (_, index){
      //           return RestModel.getFavByIndex(index);
      //         }
      //     ),
      );
  }
}
