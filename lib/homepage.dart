import 'package:flutter/material.dart';
import 'post_model.dart'; // Import the Post class
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sample_project/task4.dart';
import 'package:sample_project/task5.dart';
import 'package:sample_project/task6.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home page',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
        color: Colors.white, // Change this color to the color you want
      ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 160,
            child: Center(
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyList(),
                        ),
                      );
                    },
                    child: Text(
                      'task4',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),

                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPhotoList(),
                        ),
                      );
                    },
                    child: Text(
                      'task5',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyTODOList(),
                        ),
                      );
                    },
                    child: Text(
                      'task6',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
