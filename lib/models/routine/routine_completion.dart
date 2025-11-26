import '../../enums/routine_type.dart';

class RoutineCompletion {
  final String userId;
  final DateTime date;
  final RoutineType type;
  final Set<String> completedProductIds;
  final Set<String> skippedProductIds;
  final DateTime? completedAt;
  final int totalProducts;

  RoutineCompletion({
    required this.userId,
    required this.date,
    required this.type,
    required this.completedProductIds,
    this.skippedProductIds = const {}, // Add this parameter
    this.completedAt,
    required this.totalProducts,
  });

  String get key => '${_dateOnly(date)}_${type.name}';

  static DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Total active products (not skipped)
  int get activeProducts => totalProducts - skippedProductIds.length;

  // Check if fully completed (all non-skipped products are done)
  bool get isFullyCompleted =>
      activeProducts > 0 && completedProductIds.length == activeProducts;

  // Completion percentage based on active products only
  double get completionPercentage =>
      activeProducts > 0 ? (completedProductIds.length / activeProducts) : 0.0;

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'date': date.toIso8601String(),
    'type': type.name,
    'completedProductIds': completedProductIds.toList(),
    'skippedProductIds': skippedProductIds.toList(), // Add this
    'completedAt': completedAt?.toIso8601String(),
    'totalProducts': totalProducts,
  };

  factory RoutineCompletion.fromJson(Map<String, dynamic> json) {
    return RoutineCompletion(
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      type: RoutineType.values.firstWhere((e) => e.name == json['type']),
      completedProductIds: Set<String>.from(json['completedProductIds']),
      skippedProductIds: Set<String>.from(json['skippedProductIds'] ?? []), // Add this
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      totalProducts: json['totalProducts'] ?? 0,
    );
  }

  RoutineCompletion copyWith({
    String? userId,
    DateTime? date,
    RoutineType? type,
    Set<String>? completedProductIds,
    Set<String>? skippedProductIds, // Add this
    DateTime? completedAt,
    int? totalProducts,
  }) {
    return RoutineCompletion(
      userId: userId ?? this.userId,
      date: date ?? this.date,
      type: type ?? this.type,
      completedProductIds: completedProductIds ?? this.completedProductIds,
      skippedProductIds: skippedProductIds ?? this.skippedProductIds, // Add this
      completedAt: completedAt ?? this.completedAt,
      totalProducts: totalProducts ?? this.totalProducts,
    );
  }
}
