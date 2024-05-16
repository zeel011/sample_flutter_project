import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List of Items',
      home: MyList(),
    );
  }
}

class MyList extends StatefulWidget {
  const MyList({Key? key});

  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  late Future<List<MyListItem>> _futureList;

  @override
  void initState() {
    super.initState();
    _futureList = fetchData();
  }

  Future<List<MyListItem>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
      var data = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        List<MyListItem> myList = [];
        for (Map i in data) {
          MyListItem listItem = MyListItem(
            id: i['id'],
            title: i['title'],
            body: i['body'],
          );
          myList.add(listItem);
        }
        return myList;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'List of Items',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this color to the color you want
        ),
      ),
      body: FutureBuilder<List<MyListItem>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[300],
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: ListTile(
                    title: Text(
                      snapshot.data![index].title,
                      style: TextStyle(color: Colors.black),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Details'),
                            backgroundColor: Colors.blueGrey[50],
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('ID: ${snapshot.data![index].id}'),
                                SizedBox(height: 8),
                                Text('Title: ${snapshot.data![index].title}'),
                                SizedBox(height: 8),
                                Text('Body: ${snapshot.data![index].body}'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MyListItem {
  final int id;
  final String title;
  final String body;

  MyListItem({
    required this.id,
    required this.title,
    required this.body,
  });
}
