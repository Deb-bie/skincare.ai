class SkinTypeResult {
  final String skinType;
  final String? secondaryType;
  final bool isSensitive;
  final double confidence;
  final Map<String, double> confidenceFactors;
  final List<String> characteristics;
  final List<String> recommendations;


  SkinTypeResult({
    required this.skinType,
    this.secondaryType,
    required this.isSensitive,
    required this.confidence,
    required this.confidenceFactors,
    required this.characteristics,
    required this.recommendations,
  });

  String get displayType {
    if (isSensitive && skinType != 'Sensitive') {
      return '$skinType (Sensitive)';
    }
    if (secondaryType != null) {
      return '$skinType-$secondaryType';
    }
    return skinType;
  }

  String get confidenceLevel {
    if (confidence >= 0.90) return 'Very High';
    if (confidence >= 0.80) return 'High';
    if (confidence >= 0.70) return 'Good';
    if (confidence >= 0.60) return 'Moderate';
    return 'Fair';
  }


  Map<String, dynamic> getSummary() {
    return {
      'skinType': displayType,
      'confidence': '${(confidence * 100).toInt()}%',
      'confidenceLevel': confidenceLevel,
      'topCharacteristics': characteristics.take(3).toList(),
      'topRecommendations': recommendations.take(3).toList(),
    };
  }
}
