import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  Map<String, List<Map<String, dynamic>>> _groupedNotifications = {};

  bool get isLoading => _isLoading;
  String? get error => _error;
  Map<String, List<Map<String, dynamic>>> get groupedNotifications =>
      _groupedNotifications;

  Stream<QuerySnapshot> getNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      FirebaseFirestore.instance
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen(
            (snapshot) {
              final notifList = snapshot.docs.map((doc) {
                final data = doc.data();
                return {
                  ...data,
                  'id': doc.id,
                  'date': _formatDate(data['timestamp'] as Timestamp),
                };
              }).toList();

              _groupedNotifications = _groupNotifications(notifList);
              _isLoading = false;
              notifyListeners();
            },
            onError: (error) {
              _error = error.toString();
              _isLoading = false;
              notifyListeners();
            },
          );
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatDate(Timestamp timestamp) {
    final date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Map<String, List<Map<String, dynamic>>> _groupNotifications(
    List<Map<String, dynamic>> notifications,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var notification in notifications) {
      final date = notification['date'] as String;
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(notification);
    }

    return grouped;
  }

  Future<void> clearNotification(String notificationId) async {
    try {
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notificationId)
          .delete();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
