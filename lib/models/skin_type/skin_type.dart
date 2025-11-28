class SkinTypeModel {
  String? skinFeelByMidday;
  String? skinFeelAfterWashingFace;
  String? skinReactionToNewSkinCare;

  SkinTypeModel({
    this.skinFeelByMidday,
    this.skinFeelAfterWashingFace,
    this.skinReactionToNewSkinCare
  });

  //   JSON for storage or sending data
  Map<String, dynamic> toJson() {
    return {
      'skinFeelByMidday': skinFeelByMidday,
      'skinFeelAfterWashingFace': skinFeelAfterWashingFace,
      'skinReactionToNewSkinCare': skinReactionToNewSkinCare
    };
  }

  // factory method to receive data
  factory SkinTypeModel.fromJson(Map<String, dynamic> json) {
    return SkinTypeModel(
      skinFeelByMidday: json['skinFeelByMidday'] ?? '',
      skinFeelAfterWashingFace: json['skinFeelAfterWashingFace'] ?? '',
      skinReactionToNewSkinCare: json['skinReactionToNewSkinCare'] ?? '',
    );
  }

  double getSkinTypeAssessmentCompletionPercentage() {
    int totalFields = 5;
    int completedFields = 0;

    if (skinFeelByMidday != null) completedFields++;
    if (skinFeelAfterWashingFace != null) completedFields++;
    if (skinReactionToNewSkinCare != null) completedFields++;

    return completedFields / totalFields;
  }

  // Create a copy with updated fields
  SkinTypeModel copyWith({
    String? skinFeelByMidday,
    String? skinFeelAfterWashingFace,
    String? skinReactionToNewSkinCare
  }) {
    return SkinTypeModel(
      skinFeelByMidday: skinFeelByMidday ?? this.skinFeelByMidday,
      skinFeelAfterWashingFace: skinFeelAfterWashingFace ?? this.skinFeelAfterWashingFace,
      skinReactionToNewSkinCare: skinReactionToNewSkinCare ?? this.skinReactionToNewSkinCare,
    );
  }

}

