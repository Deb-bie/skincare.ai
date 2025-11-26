
enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get displayName {
    switch (this) {
      case DayOfWeek.monday:
        return 'Monday';
      case DayOfWeek.tuesday:
        return 'Tuesday';
      case DayOfWeek.wednesday:
        return 'Wednesday';
      case DayOfWeek.thursday:
        return 'Thursday';
      case DayOfWeek.friday:
        return 'Friday';
      case DayOfWeek.saturday:
        return 'Saturday';
      case DayOfWeek.sunday:
        return 'Sunday';
    }
  }

  String get shortName {
    switch (this) {
      case DayOfWeek.monday:
        return 'Mon';
      case DayOfWeek.tuesday:
        return 'Tue';
      case DayOfWeek.wednesday:
        return 'Wed';
      case DayOfWeek.thursday:
        return 'Thu';
      case DayOfWeek.friday:
        return 'Fri';
      case DayOfWeek.saturday:
        return 'Sat';
      case DayOfWeek.sunday:
        return 'Sun';
    }
  }

  String get letterName {
    switch (this) {
      case DayOfWeek.monday:
        return 'M';
      case DayOfWeek.tuesday:
        return 'T';
      case DayOfWeek.wednesday:
        return 'W';
      case DayOfWeek.thursday:
        return 'T';
      case DayOfWeek.friday:
        return 'F';
      case DayOfWeek.saturday:
        return 'S';
      case DayOfWeek.sunday:
        return 'S';
    }
  }
}

