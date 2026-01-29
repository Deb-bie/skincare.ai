abstract class Syncable {
  String get id;
  String get localUserId;
  String? get firebaseUid;
  bool get isSynced;
  bool get isDeleted;
  DateTime get updatedAt;

  Map<String, dynamic> toFirebaseMap();
  String firebasePath(String uid);
}