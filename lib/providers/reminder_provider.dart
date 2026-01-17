import 'package:flutter/foundation.dart';

import '../services/data_manager/data_manager.dart';
import '../services/data_manager/hive_models/reminders/hive_reminder_model.dart';
import '../services/notifications/notifications_service.dart';

class ReminderProvider extends ChangeNotifier {
  final DataManager _dataManager = DataManager();
  final NotificationService _notificationService = NotificationService();
  List<HiveReminderModel> _reminders = [];

  List<HiveReminderModel> get reminders => _reminders;


  Future<void> initializeNotifications() async {
    await _notificationService.initialize();
  }


  Future<bool> requestNotificationPermissions() async {
    return await _notificationService.requestPermissions();
  }


  Future<void> loadReminders() async {
    _reminders = await _dataManager.getAllReminders();
    notifyListeners();
  }


  Future<void> createReminder({
    required String title,
    required String time,
    required String icon,
    bool isEnabled = true,
    String? notes,
  }) async {
    final reminderId = await _dataManager.createReminder(
      title: title,
      time: time,
      icon: icon,
      isEnabled: isEnabled,
      notes: notes,
    );

    // Schedule notification if enabled
    if (isEnabled) {
      final timeParts = _parseTime(time);
      if (timeParts != null) {
        await _notificationService.scheduleDailyReminder(
          id: reminderId.hashCode,
          title: title,
          body: notes ?? 'Time for your skincare routine! ✨',
          hour: timeParts['hour']!,
          minute: timeParts['minute']!,
          payload: 'reminder:$reminderId',
        );
      }
    }

    await loadReminders();
  }



  Future<void> updateReminder({
    required String reminderId,
    String? title,
    String? time,
    String? icon,
    bool? isEnabled,
    String? notes,
  }) async {
    final reminder = _dataManager.getReminderById(reminderId);
    if (reminder == null) return;

    await _dataManager.updateReminder(
      reminderId: reminderId,
      title: title,
      time: time,
      icon: icon,
      isEnabled: isEnabled,
      notes: notes,
    );

    // Reschedule notification
    await _notificationService.cancelNotification(reminderId.hashCode);

    final updatedReminder = _dataManager.getReminderById(reminderId);
    if (updatedReminder?.isEnabled == true) {
      final timeParts = _parseTime(updatedReminder!.time!);
      if (timeParts != null) {
        await _notificationService.scheduleDailyReminder(
          id: reminderId.hashCode,
          title: updatedReminder.title ?? 'Skincare Reminder',
          body: updatedReminder.notes ?? 'Time for your skincare routine! ✨',
          hour: timeParts['hour']!,
          minute: timeParts['minute']!,
          payload: 'reminder:$reminderId',
        );
      }
    }
    await loadReminders();
  }


  Future<void> toggleReminderStatus(String reminderId, bool isEnabled) async {
    await _dataManager.updateReminder(
      reminderId: reminderId,
      isEnabled: isEnabled,
    );

    // Cancel or schedule notification
    if (!isEnabled) {
      await _notificationService.cancelNotification(reminderId.hashCode);
    } else {
      final reminder = _dataManager.getReminderById(reminderId);
      if (reminder != null) {
        final timeParts = _parseTime(reminder.time!);
        if (timeParts != null) {
          await _notificationService.scheduleDailyReminder(
            id: reminderId.hashCode,
            title: reminder.title ?? 'Skincare Reminder',
            body: reminder.notes ?? 'Time for your skincare routine! ✨',
            hour: timeParts['hour']!,
            minute: timeParts['minute']!,
            payload: 'reminder:$reminderId',
          );
        }
      }
    }
    await loadReminders();
  }


  Future<void> deleteReminder(String reminderId) async {
    await _notificationService.cancelNotification(reminderId.hashCode);

    await _dataManager.deleteReminder(reminderId);
    await loadReminders();
  }


  HiveReminderModel? getReminderById(String reminderId) {
    return _dataManager.getReminderById(reminderId);
  }

  Future<void> rescheduleAllReminders() async {
    for (final reminder in _reminders) {
      if (reminder.isEnabled == true && reminder.time != null) {
        final timeParts = _parseTime(reminder.time!);
        if (timeParts != null) {
          await _notificationService.scheduleDailyReminder(
            id: reminder.id.hashCode,
            title: reminder.title ?? 'Skincare Reminder',
            body: reminder.notes ?? 'Time for your skincare routine! ✨',
            hour: timeParts['hour']!,
            minute: timeParts['minute']!,
            payload: 'reminder:${reminder.id}',
          );
        }
      }
    }
  }

  Map<String, int>? _parseTime(String time) {
    try {
      final parts = time.split(' ');
      if (parts.length != 2) return null;

      final timeParts = parts[0].split(':');
      if (timeParts.length != 2) return null;

      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = parts[1].toUpperCase();

      // Convert to 24-hour format
      if (period == 'PM' && hour != 12) {
        hour += 12;
      } else if (period == 'AM' && hour == 12) {
        hour = 0;
      }

      return {'hour': hour, 'minute': minute};
    } catch (e) {
      print('Error parsing time: $e');
      return null;
    }
  }



}