import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Album {
  int userId;
  int id;
  String title;

  Album(int _userId, int _id, String _title) {
    this.userId = _userId;
    this.id = _id;
    this.title = _title;
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(json['userId'], json['id'], json['title']);
  }
}

Future<Album> fetchAlbum() async {
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/2'));

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  }
  else {
    throw Exception('Failed to load album');
  }
}