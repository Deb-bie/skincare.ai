import '../routine/routine_model.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final Map<String, RoutineModel> routines;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    Map<String, RoutineModel>? routines,
  })
      : routines = routines ?? {};




//   factory method to receive json data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final routinesData = json['routines'] as Map<String, dynamic>?;

    final routines = routinesData?.map(
            (key, value) => MapEntry(
                key, RoutineModel.fromJson(
                Map<String, dynamic>.from(value)
            )
            )
    ) ?? {};

    return UserModel(
        id: json['id'] ?? '',
        username: json['username'] ?? '',
        email: json['email'] ?? '',
        password: json['password'] ?? '',
        routines: routines
    );
  }


  // for sending data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'routines': routines.map((key, value) => MapEntry(key, value.toJson())),
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
        password: password ?? this.password,
        routines: {}
    );
  }
}