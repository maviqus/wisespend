import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum NotificationType { success, error, info, warning }

class NotificationWidget {
  static void show(
    BuildContext context,
    String message, {
    NotificationType type = NotificationType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    ToastificationType toastType;
    Color? bgColor;
    IconData? iconData;

    switch (type) {
      case NotificationType.success:
        toastType = ToastificationType.success;
        bgColor = Colors.green.shade600;
        iconData = Icons.check_circle;
        break;
      case NotificationType.error:
        toastType = ToastificationType.error;
        bgColor = Colors.red.shade600;
        iconData = Icons.delete_forever;
        break;
      case NotificationType.warning:
        toastType = ToastificationType.warning;
        bgColor = Colors.orange.shade700;
        iconData = Icons.warning;
        break;
      default:
        toastType = ToastificationType.info;
        bgColor = Colors.blue.shade600;
        iconData = Icons.info;
    }

    toastification.show(
      context: context,
      type: toastType,
      title: Text(message, style: const TextStyle(fontFamily: 'Roboto')),
      autoCloseDuration: duration,
      backgroundColor: bgColor,
      icon: Icon(iconData, color: Colors.white),
    );
  }
}
