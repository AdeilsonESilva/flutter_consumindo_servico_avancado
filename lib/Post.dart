import 'dart:convert';

class Post {
  int userId;
  int id;
  String title;
  String body;

  Post(
    this.userId,
    this.id,
    this.title,
    this.body,
  );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = Map();

    if (userId != null) {
      result['userId'] = userId;
    }
    if (id != null) {
      result['id'] = id;
    }
    if (title != null) {
      result['title'] = title;
    }

    if (body != null) {
      result['body'] = body;
    }

    return result;
  }

  static Post fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Post(
      map['userId'],
      map['id'],
      map['title'],
      map['body'],
    );
  }

  String toJson() => json.encode(toMap());

  static Post fromJson(String source) => fromMap(json.decode(source));
}
