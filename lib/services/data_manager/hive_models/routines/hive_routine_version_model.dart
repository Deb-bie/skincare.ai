
import 'package:hive/hive.dart';

import '../../../../models/product/product_model.dart';

part 'hive_routine_version_model.g.dart';

@HiveType(typeId: 3)
class HiveRoutineVersion extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String routineId;

  @HiveField(2)
  String localUserId;

  @HiveField(3)
  String? firebaseUid;

  @HiveField(4)
  String? name;

  @HiveField(5)
  Map<String, List<ProductModel>>? productsByCategory;

  @HiveField(6)
  DateTime createdAt;

  HiveRoutineVersion({
    required this.id,
    required this.routineId,
    required this.localUserId,
    this.firebaseUid,
    this.name,
    this.productsByCategory,
    required this.createdAt
  });

  Map<String, dynamic> toFirebaseMap() => {
    'routineId': routineId,
    'name': name,
    'productsByCategory': productsByCategory,
    'createdAt': createdAt,
  };
}

