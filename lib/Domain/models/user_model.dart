class UserModel {
  int? id;
  String name;
  String email;
  String password;
  String token;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.token = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> doc) {
    return UserModel(
      id: doc['id'],
      name: doc['name'],
      email: doc['email'],
      password: doc['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
      'email': email,
      'token': token,
    };
  }
}
