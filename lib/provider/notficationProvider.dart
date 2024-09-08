import 'package:flutter/material.dart';
import '../Data_Models/notificationModel.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  // Calculate the number of unread notifications
  int get unreadNotificationCount {
    return _notifications.where((notification) => !notification.isRead).length;
  }

  // Get the total count of notifications
  int get notificationCount => _notifications.length;

  // Add a notification
  void addNotification(NotificationModel notification) {
    // Insert the notification at the first index
    _notifications.insert(0, notification);
    notifyListeners();
  }

  // Remove a notification
  void removeNotification(NotificationModel notification) {
    _notifications.remove(notification);
    notifyListeners();
  }

  // Clear all notifications
  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  // Mark all notifications as read
  void markAllAsRead() {
    for (var notification in _notifications) {
      notification.isRead = true;
    }
    notifyListeners();
  }

  // Mark a specific notification as read
  void markAsRead(NotificationModel notification) {
    final index = _notifications.indexOf(notification);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }
}
