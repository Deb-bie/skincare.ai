import 'package:flutter/foundation.dart';

import '../enums/notification_type.dart';
import '../services/data_manager/data_manager.dart';
import '../services/data_manager/hive_models/notifications/hive_notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final DataManager _dataManager = DataManager();
  List<HiveNotificationModel> _notifications = [];

  List<HiveNotificationModel> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;


  Future<void> loadNotifications() async {
    _notifications = await _dataManager.getAllNotifications();
    notifyListeners();
  }


  Future<void> createNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? actionData,
    String? imageUrl,
  }) async {
    await _dataManager.createNotification(
      title: title,
      body: body,
      type: type,
      actionData: actionData,
      imageUrl: imageUrl,
    );
    await loadNotifications();
  }


  Future<void> markAsRead(String notificationId) async {
    await _dataManager.markNotificationAsRead(notificationId);
    await loadNotifications();
  }


  Future<void> markAllAsRead() async {
    for (final notification in _notifications) {
      if (!notification.isRead) {
        await _dataManager.markNotificationAsRead(notification.id);
      }
    }
    await loadNotifications();
  }


  Future<void> deleteNotification(String notificationId) async {
    await _dataManager.deleteNotification(notificationId);
    await loadNotifications();
  }


  Future<void> clearReadNotifications() async {
    final readNotifications = _notifications.where((n) => n.isRead).toList();
    for (final notification in readNotifications) {
      await _dataManager.deleteNotification(notification.id);
    }
    await loadNotifications();
  }



  Future<void> createReminderNotification({
    required String reminderTitle,
    required bool isCompleted,
  }) async {
    await createNotification(
      title: isCompleted ? 'Reminder Completed! 🎉' : 'Reminder Missed',
      body: isCompleted
          ? 'Great job completing your $reminderTitle!'
          : 'You missed your $reminderTitle reminder',
      type: NotificationType.reminder,
    );
  }

  Future<void> createRoutineNotification({
    required String routineType,
    required int productsCompleted,
    required int totalProducts,
  }) async {
    await createNotification(
      title: 'Routine Completed! ✨',
      body: 'You completed your $routineType routine ($productsCompleted/$totalProducts products)',
      type: NotificationType.routine,
    );
  }

  Future<void> createStreakNotification(int streakDays) async {
    String emoji = streakDays >= 30 ? '🏆' : streakDays >= 7 ? '🔥' : '⭐';
    await createNotification(
      title: '$streakDays Day Streak! $emoji',
      body: 'Amazing! You\'ve maintained your routine for $streakDays days in a row',
      type: NotificationType.streak,
    );
  }

  Future<void> createAchievementNotification({
    required String achievementName,
    required String description,
  }) async {
    await createNotification(
      title: 'Achievement Unlocked! 🏆',
      body: '$achievementName: $description',
      type: NotificationType.achievement,
    );
  }

  Future<void> createTipNotification({
    required String tip,
  }) async {
    await createNotification(
      title: 'Skincare Tip 💡',
      body: tip,
      type: NotificationType.tip,
    );
  }

  Future<void> createProductExpiryNotification({
    required String productName,
    required int daysLeft,
  }) async {
    await createNotification(
      title: 'Product Expiring Soon ⚠️',
      body: '$productName will expire in $daysLeft days',
      type: NotificationType.productExpiry,
    );
  }
}


