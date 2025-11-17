
class AssessmentModel {
  String? gender;
  String? ageRange;
  String? skinType;
  Set<String>? skinConcerns;
  String? currentRoutine;

  AssessmentModel({
    this.gender,
    this.ageRange,
    this.skinType,
    this.skinConcerns = const {},
    this.currentRoutine,
  });

  // JSON for storage or sending data
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'ageRange': ageRange,
      'skinType': skinType,
      'skinConcerns': skinConcerns?.toList(),
      'currentRoutine': currentRoutine,
    };
  }

  // factory method to receive data
  factory AssessmentModel.fromJson(Map<String, dynamic> json) {
    return AssessmentModel(
      gender: json['gender'] ?? '',
      ageRange: json['ageRange'] ?? '',
      skinType: json['skinType'] ?? '',
      skinConcerns: Set<String>.from(json['skinConcerns']),
      currentRoutine: json['currentRoutine'] ?? '',
    );
  }

  double getAssessmentCompletionPercentage() {
    int totalFields = 5;
    int completedFields = 0;

    if (gender != null) completedFields++;
    if (ageRange != null) completedFields++;
    if (skinType != null) completedFields++;
    if (skinConcerns!.isNotEmpty) completedFields++;
    if (currentRoutine != null) completedFields++;

    return completedFields / totalFields;
  }

  // Create a copy with updated fields
  AssessmentModel copyWith({
    String? gender,
    String? ageRange,
    String? skinType,
    Set<String>? skinConcerns,
    String? skinSensitivity,
    String? currentRoutine,
  }) {
    return AssessmentModel(
      gender: gender ?? this.gender,
      ageRange: ageRange ?? this.ageRange,
      skinType: skinType ?? this.skinType,
      skinConcerns: skinConcerns ?? this.skinConcerns,
      currentRoutine: currentRoutine ?? this.currentRoutine,
    );
  }

}

