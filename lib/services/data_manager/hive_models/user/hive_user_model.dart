import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

part 'hive_user_model.g.dart';

@HiveType(typeId: 1)
class HiveUserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? username;

  @HiveField(3)
  final String? photoURL;

  @HiveField(4)
  final DateTime? lastLoginTime;

  HiveUserModel({
    required this.uid,
    this.email,
    this.username,
    this.photoURL,
    this.lastLoginTime,
  });

  // Factory to create from Firebase User
  factory HiveUserModel.fromFirebaseUser(User user) {
    return HiveUserModel(
      uid: user.uid,
      email: user.email,
      username: user.displayName,
      photoURL: user.photoURL,
      lastLoginTime: DateTime.now(),
    );
  }
}