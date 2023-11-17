import 'package:flutter/material.dart';
import 'package:flutter_application_apiget/Album.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Async Example')),
        body: FutureBuilder(
          future: fetchAlbum(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return ListView.builder(
                  itemCount:
                      snapshot.data?.length, // Number of items in the list
                  itemBuilder: (BuildContext context, int index) {
                    // Build each list item based on its index
                    return ListTile(
                      title: Text('Album ${snapshot.data?[index].title}'),
                      onTap: () {
                        // Handle item tap
                        print('Tapped on item $index');
                      },
                    );
                  });
            }
          },
        ),
      ),
    );
  }

  Future<List<Album>> fetchAlbum() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<Map<String,dynamic>> albumsJson = json.decode(response.body).cast<Map<String, dynamic>>().toList();
      List<Album> albums =
          albumsJson.map((album) => Album.fromJson(album)).toList();

      return albums;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
