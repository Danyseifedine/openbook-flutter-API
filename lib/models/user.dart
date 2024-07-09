class User {
  int? id;
  String? name;
  String? email;
  String? token;

  User({
    this.id,
    this.email,
    this.token,
    this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      token: json['token'],
    );
  }
}
