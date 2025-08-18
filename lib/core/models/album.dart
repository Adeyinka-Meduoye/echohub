// Directory: lib/core/models

import 'package:echohub/core/models/photo.dart';

class Album {
  final int id;
  final int userId;
  final String title;
  final List<Photo> photos;

  Album({
    required this.id,
    required this.userId,
    required this.title,
    this.photos = const [],
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      photos: [], // Photos are fetched separately
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
    };
  }
}