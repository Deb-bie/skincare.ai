import 'package:hive/hive.dart';

import '../../../../models/product/product_model.dart';
import '../../syncable.dart';

part 'hive_routine_model.g.dart';

@HiveType(typeId: 2)
class HiveRoutineModel extends HiveObject implements Syncable {
  @override
  @HiveField(0)
  String id;

  @override
  @HiveField(1)
  String localUserId;

  @override
  @HiveField(2)
  String? firebaseUid;

  @HiveField(3)
  String? name;

  @HiveField(4)
  Map<String, List<ProductModel>>? productsByCategory;

  @HiveField(5)
  Map<String, dynamic>? morningRoutinesJson;

  @HiveField(6)
  Map<String, dynamic>? eveningRoutinesJson;

  @HiveField(7)
  Map<String, dynamic>? completionsJson;


  @override
  @HiveField(8)
  bool isSynced;

  @override
  @HiveField(9)
  bool isDeleted;

  @override
  @HiveField(10)
  DateTime updatedAt;

  @HiveField(11)
  DateTime createdAt;

  HiveRoutineModel({
    required this.id,
    required this.localUserId,
    this.firebaseUid,
    this.name,
    this.productsByCategory,
    this.morningRoutinesJson,
    this.eveningRoutinesJson,
    this.completionsJson,
    this.isSynced = false,
    this.isDeleted = false,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toFirebaseMap() => {
    'name': name,
    'productsByCategory': productsByCategory,
    'morningRoutines': morningRoutinesJson,
    'eveningRoutines': eveningRoutinesJson,
    'completions': completionsJson,
    'updatedAt': updatedAt,
    'createdAt': createdAt
  };

  @override
  String firebasePath(String uid) => 'users/$uid/routines';

}
