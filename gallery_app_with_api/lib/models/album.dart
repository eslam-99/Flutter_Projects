import 'package:flutter/foundation.dart';

class Album {
  final albumId;
  final id;
  final title;
  final url;
  final thumbnailUrl;

  Album({
    @required this.albumId,
    @required this.id,
    @required this.title,
    @required this.url,
    @required this.thumbnailUrl,
  });

  factory Album.fromJson(Map<String, dynamic> jsonData) {
    return Album(
      albumId: jsonData[""],
      id: jsonData["id"],
      title: jsonData["title"],
      url: jsonData["url"],
      thumbnailUrl: jsonData["thumbnailUrl"],
    );
  }
}
