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
      title: 'Photo Album',
      home: MyPhotoList(),
    );
  }
}

class MyPhotoList extends StatefulWidget {
  const MyPhotoList({Key? key});

  @override
  _MyPhotoListState createState() => _MyPhotoListState();
}

class _MyPhotoListState extends State<MyPhotoList> {
  late Future<List<Photo>> _futurePhotos;

  @override
  void initState() {
    super.initState();
    _futurePhotos = fetchPhotos();
  }

  Future<List<Photo>> fetchPhotos() async {
    final response =
    await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Photo> photos = data.map((item) => Photo.fromJson(item)).toList();
      return photos;
    } else {
      throw Exception('Failed to load photos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Photo Album',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(
          color: Colors.white, // Change this color to the color you want
        ),
      ),
      body: FutureBuilder<List<Photo>>(
        future: _futurePhotos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('photo id:'+ snapshot.data![index].id.toString()),
                  subtitle: Text(snapshot.data![index].title.toString()),
                  leading: CircleAvatar(
                    backgroundImage:NetworkImage(snapshot.data![index].thumbnailUrl) ,
                    //fit: BoxFit.cover,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoDetailPage(
                          photo: snapshot.data![index],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Photo {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String imageUrl;

  Photo({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.imageUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      imageUrl: json['url'] as String,
    );
  }
}

class PhotoDetailPage extends StatelessWidget {
  final Photo photo;

  const PhotoDetailPage({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('photo id:'+ photo.id.toString()),
      ),
      body: Center(
        child: Image.network(
          photo.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}