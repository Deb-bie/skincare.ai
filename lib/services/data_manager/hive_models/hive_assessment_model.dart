import 'package:hive/hive.dart';
import '../syncable.dart';
part 'hive_assessment_model.g.dart';

@HiveType(typeId: 0)
class HiveAssessmentModel extends HiveObject implements Syncable {
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
  String? gender;

  @HiveField(4)
  String? ageRange;

  @HiveField(5)
  String? skinType;

  @HiveField(6)
  List<String>? skinConcerns;

  @HiveField(7)
  String? currentRoutine;

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

  HiveAssessmentModel({
    required this.id,
    required this.localUserId,
    this.firebaseUid,
    this.gender,
    this.ageRange,
    this.skinType,
    this.skinConcerns,
    this.currentRoutine,
    this.isSynced = false,
    this.isDeleted = false,
    required this.updatedAt,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toFirebaseMap() => {
    'gender': gender,
    'ageRange': ageRange,
    'skinType': skinType,
    'skinConcerns': skinConcerns?.toList(),
    'currentRoutine': currentRoutine,
    'updatedAt': updatedAt,
    'createdAt': createdAt
  };

  @override
  String firebasePath(String uid) => 'users/$uid/assessments';

  double getAssessmentCompletionPercentage() {
    int totalFields = 5;
    int completedFields = 0;

    if (skinType != null && skinType!.isNotEmpty) completedFields++;
    if (skinConcerns != null && skinConcerns!.isNotEmpty) completedFields++;
    if (currentRoutine != null && currentRoutine!.isNotEmpty) completedFields++;
    if (ageRange != null && ageRange!.isNotEmpty) completedFields++;
    if (gender != null && gender!.isNotEmpty) completedFields++;

    return completedFields / totalFields;
  }
}