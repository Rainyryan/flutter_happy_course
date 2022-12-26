import 'package:flutter/material.dart';

import 'rest.dart';
import 'rest_card.dart';
import 'rest_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  String? selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    if(selectedCategory == 'All'){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('成大附近的餐廳'),
          actions: [
            IconButton(onPressed: (){
              Navigator.pushNamed(context, '/favorite');
            }, icon: Icon(Icons.favorite)),
          ],
        ),
            body: Column(
              children: [
                Row(
                  children: [
                    Text('Category'),
                    DropdownButton(
                      value: selectedCategory,
                      onChanged: (String? newCategory) {
                        setState(() {
                          selectedCategory = newCategory;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All'),
                        ),
                        DropdownMenuItem(
                          value: '0',
                          child: Text('台式'),
                        ),
                        DropdownMenuItem(
                          value: '1',
                          child: Text('日式'),
                        ),
                        DropdownMenuItem(
                          value: '2',
                          child: Text('義式'),
                        ),
                        DropdownMenuItem(
                          value: '3',
                          child: Text('美式'),
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                child :Container(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView(
                    children: <Widget>[
                      Text('台式', style: TextStyle(fontSize: 20)),
                      Container(
                        height: 180,
                        color: Colors.redAccent,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (_, index){
                              Rest rest = RestModel.getMovieByIndex(0, index);
                              return RestCard(image: Image.asset(rest.imagePath), title: rest.title, plot: rest.plot);
                            }
                        )
                      ),
                      Text('日式', style: TextStyle(fontSize: 20)),
                      Container(
                          height: 180,
                          color: Colors.lime,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (_, index){
                                Rest rest = RestModel.getMovieByIndex(1, index);
                                return RestCard(image: Image.asset(rest.imagePath), title: rest.title, plot: rest.plot);
                              }
                          )
                      ),
                      Text('義式', style: TextStyle(fontSize: 20)),
                      Container(
                          height: 180,
                          color: Colors.cyan,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (_, index){
                                Rest rest = RestModel.getMovieByIndex(2, index);
                                return RestCard(image: Image.asset(rest.imagePath), title: rest.title, plot: rest.plot);
                              }
                          )
                      ),
                      Text('美式', style: TextStyle(fontSize: 20)),
                      Container(
                          height: 180,
                          color: Colors.orangeAccent,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 3,
                              itemBuilder: (_, index){
                                Rest rest = RestModel.getMovieByIndex(3, index);
                                return RestCard(image: Image.asset(rest.imagePath), title: rest.title, plot: rest.plot);
                              }
                          )
                      )
                    ],
                  )
                ),
                )
              ],
            )
      ),
    );
    }else{
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('成大附近的餐廳'),
            actions: [
              IconButton(onPressed: (){
                Navigator.pushNamed(context, '/favorite');
              }, icon: Icon(Icons.favorite)),
            ],
          ),
          body: Column(
            children: [
              Row(
                children: [
                  Text('Category'),
                  DropdownButton(
                    value: selectedCategory,
                    onChanged: (String? newCategory) {
                      setState(() {
                        selectedCategory = newCategory;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All'),
                      ),
                      DropdownMenuItem(
                        value: '0',
                        child: Text('台式'),
                      ),
                      DropdownMenuItem(
                        value: '1',
                        child: Text('日式'),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        child: Text('義式'),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Text('美式'),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (_, index){
                      late final rest;
                      if(selectedCategory == '0') rest = RestModel.getMovieByIndex(0, index);
                      else if(selectedCategory == '1') rest = RestModel.getMovieByIndex(1, index);
                      else if(selectedCategory == '2') rest = RestModel.getMovieByIndex(2, index);
                      else if(selectedCategory == '3') rest = RestModel.getMovieByIndex(3, index);
                      return RestCard(image: Image.asset(rest.imagePath), title: rest.title, plot: rest.plot);
                      }
                ),
              ),
            ],
          )
        ),
      );
    }
  }
}
