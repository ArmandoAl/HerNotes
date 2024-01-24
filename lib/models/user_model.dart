class UserModel {
  int? id;
  String name;
  String email;
  String password;
  List<String> tokens = [];

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
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
      'uid': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
