class SkinTypeAnalysis {
  final String primary;
  final String? secondary;
  final bool isSensitive;
  final double primaryScore;
  final double sensitiveScore;
  final String? skinTypeMeaning;
  final String? typePersonalizedInsight;

  SkinTypeAnalysis({
    required this.primary,
    this.secondary,
    required this.isSensitive,
    required this.primaryScore,
    required this.sensitiveScore,
    this.skinTypeMeaning,
    this.typePersonalizedInsight,

  });
}