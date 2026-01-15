import '../../enums/day_of_week.dart';
import 'day_routine.dart';

class WeeklyRoutine {
  final String? userId;
  final Map<DayOfWeek, DayRoutine> morningRoutines;
  final Map<DayOfWeek, DayRoutine> eveningRoutines;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;

  WeeklyRoutine({
    this.userId,
    required this.morningRoutines,
    required this.eveningRoutines,
    required this.createdAt,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'morningRoutines': morningRoutines.map(
          (key, value) => MapEntry(key.toString(), value.toJson()),
    ),
    'eveningRoutines': eveningRoutines.map(
          (key, value) => MapEntry(key.toString(), value.toJson()),
    ),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'isSynced': isSynced,
  };

  factory WeeklyRoutine.fromJson(Map<String, dynamic> json) {
    return WeeklyRoutine(
      userId: json['userId'],
      morningRoutines: (json['morningRoutines'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          DayOfWeek.values.firstWhere((d) => d.toString() == key),
          DayRoutine.fromJson(value),
        ),
      ),
      eveningRoutines: (json['eveningRoutines'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(
          DayOfWeek.values.firstWhere((d) => d.toString() == key),
          DayRoutine.fromJson(value),
        ),
      ),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isSynced: json['isSynced'] ?? false,
    );
  }

  WeeklyRoutine copyWith({
    String? userId,
    Map<DayOfWeek, DayRoutine>? morningRoutines,
    Map<DayOfWeek, DayRoutine>? eveningRoutines,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return WeeklyRoutine(
      userId: userId ?? this.userId,
      morningRoutines: morningRoutines ?? this.morningRoutines,
      eveningRoutines: eveningRoutines ?? this.eveningRoutines,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
