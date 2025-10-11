class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password
  });


//   factory method to receive json data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] ?? '',
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? ''
    );
  }


  // for sending data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password
    };
  }


  // copy method to update individual fields immutably
  UserModel copyWith({
    String? username,
    String? email,
    String? password
  }) {
    return UserModel(
        id: id,
        username: username ?? this.username,
        email: email ?? this.email,
        password: password ?? this.password
    );
  }


}