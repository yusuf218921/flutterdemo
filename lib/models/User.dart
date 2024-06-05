// ignore_for_file: file_names

class User {
  int? userId;
  String username;
  String password;
  String email;

  User(
      {this.userId,
      required this.username,
      required this.password,
      required this.email});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'username': username,
      'password': password,
      'email': email,
    };
    if (userId != null) {
      map['userId'] = userId;
    }
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
    );
  }
}
