import 'package:hive/hive.dart';

part 'hive_routine_completion.g.dart';

@HiveType(typeId: 4)
class HiveRoutineCompletion extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String localUserId;

  @HiveField(2)
  String? firebaseUid;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String routineType;

  @HiveField(5)
  List<String> completedProductIds;

  @HiveField(6)
  List<String> skippedProductIds;

  @HiveField(7)
  int totalProducts;

  @HiveField(8)
  DateTime? completedAt;

  @HiveField(9)
  DateTime createdAt;

  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  bool isSynced;

  HiveRoutineCompletion({
    required this.id,
    required this.localUserId,
    this.firebaseUid,
    required this.date,
    required this.routineType,
    required this.completedProductIds,
    required this.skippedProductIds,
    required this.totalProducts,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  bool get isFullyCompleted {
    final activeProducts = totalProducts - skippedProductIds.length;
    return activeProducts > 0 && completedProductIds.length >= activeProducts;
  }

  double get completionPercentage {
    final activeProducts = totalProducts - skippedProductIds.length;
    if (activeProducts == 0) return 0.0;
    return completedProductIds.length / activeProducts;
  }

  Map<String, dynamic> toFirebaseMap() => {
    'date': date.toIso8601String(),
    'routineType': routineType,
    'completedProductIds': completedProductIds.toList(),
    'skippedProductIds': skippedProductIds.toList(),
    'totalProducts': totalProducts,
    'completedAt': completedAt?.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory HiveRoutineCompletion.fromFirebaseMap(Map<String, dynamic> map, String id, String localUserId, String? firebaseUid) {
    return HiveRoutineCompletion(
      id: id,
      localUserId: localUserId,
      firebaseUid: firebaseUid,
      date: DateTime.parse(map['date']),
      routineType: map['routineType'],
      completedProductIds: (map['completedProductIds'] as List).cast<String>(),
      skippedProductIds: (map['skippedProductIds'] as List).cast<String>(),
      totalProducts: map['totalProducts'],
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: true,
    );
  }
}