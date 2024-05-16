import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO List',
      home: const MyTODOList(),
    );
  }
}

class MyTODOList extends StatefulWidget {
  const MyTODOList({Key? key}) : super(key: key);

  @override
  _MyTODOListState createState() => _MyTODOListState();
}

class _MyTODOListState extends State<MyTODOList> {
  late Future<List<Todo>> _futureTodos;

  @override
  void initState() {
    super.initState();
    _futureTodos = fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Todo.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  void _performSearch(String query) {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      setState(() {
        if (query.isEmpty) {
          _futureTodos = fetchTodos();
        } else {
          _futureTodos = fetchTodos().then((todos) => todos
              .where((todo) => todo.title.toLowerCase().contains(query.toLowerCase()))
              .toList());
        }
      });
    });
  }

  void _sortById() {
    setState(() {
      _futureTodos = _futureTodos.then((todos) => todos..sort((a, b) => a.id.compareTo(b.id)));
    });
  }

  void _filterByCompletion(bool completed) {
    setState(() {
      _futureTodos = _futureTodos.then((todos) => todos.where((todo) => todo.completed == completed).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(
          color: Colors.white, // Change this color to the color you want
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: TodoSearchDelegate(_performSearch));
            },
          ),
          IconButton(
            icon: Icon(Icons.sort, color: Colors.white),
            onPressed: _sortById,
          ),
          IconButton(
            icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
            onPressed: () {
              _filterByCompletion(true);
            },
          ),
        ],
        backgroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<Todo>>(
        future: _futureTodos,
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
                    title: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        snapshot.data![index].title,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        'Completed: ${snapshot.data![index].completed}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Add other details as needed
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

class Todo {
  final int id;
  final String title;
  final bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }
}

class TodoSearchDelegate extends SearchDelegate<String> {
  final Function(String) onSearch;

  TodoSearchDelegate(this.onSearch);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onSearch(query);
    return Container(); // We don't need to show results in this widget
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // We don't need to show suggestions in this widget
  }
}
