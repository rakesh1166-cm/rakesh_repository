import 'dart:convert';

class User {
  int id;
  String name;
  String email;
  String slug;
  String status;
  String filePic;
  String password;

  User({
    this.id = 0,
    required this.name,
    required this.email,
    required this.slug,
    required this.status,
    required this.filePic,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map["id"] ?? 0,
      name: map["name"],
      email: map["email"],
      slug: map["slug"],
      status: map["status"],
      filePic: map["file_pic"],
      password: map["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "slug": slug,
      "status": status,
      "file_pic": filePic,
      "password": password,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, slug: $slug, status: $status, filePic: $filePic, password: $password}';
  }
}

List<User> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data.map((item) => User.fromJson(item)));
}

String userToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}