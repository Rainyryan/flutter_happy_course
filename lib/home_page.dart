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
  String? selectedCategory = 'taipei';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('成大附近的餐廳', style: TextStyle(fontSize: 30)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/favorite');
              },
              icon: const Icon(Icons.favorite),
            ),
          ]),
      body: Column(
        children: [
          //  Placeholder(fallbackHeight: 30),
          Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'Category: ',
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  DropdownButton(
                    value: selectedCategory,
                    onChanged: (String? newCategory) {
                      setState(() {
                        selectedCategory = newCategory;
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'taipei',
                        child: Text(
                          'Taipei',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'chiayi',
                        child: Text(
                          'Chiayi',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'hwalian',
                        child: Text(
                          'Hwalian',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'tainan',
                        child: Text(
                          'Tainan',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Bangkok',
                        child: Text(
                          'Bangkok',
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          FutureBuilder(
              future: RestModel.getRest(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final restaurants = snapshot.data as List<Rest>;
                  return Expanded(
                      child: ListView.builder(
                        itemCount: restaurants.length,
                        itemBuilder: (context, index) {
                          return RestCard(
                            imagePath: restaurants.elementAt(index).imagePath,
                            title: restaurants.elementAt(index).title,
                            plot: restaurants.elementAt(index).title,
                          );
                        },
                      ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              })
        ],
      ),
    );
  }
}
