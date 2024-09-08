import 'package:flutter/cupertino.dart';

class NotificationModel {
  final IconData icon;
  final String title;
  final String description;
  final String time;
  final Color statusColor;
  final Color? tileColor;
  bool isRead; // Add this property to track read status

  NotificationModel({
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    required this.statusColor,
    this.tileColor,
    this.isRead = false, // Default to unread
  });
}
