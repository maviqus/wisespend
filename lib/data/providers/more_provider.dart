import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/core/widgets/notification_widget.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';

class MoreProvider extends ChangeNotifier {
  final TextEditingController categoryNameController = TextEditingController();
  bool isLoading = false;

  Future<void> addCategory(BuildContext context) async {
    final name = categoryNameController.text.trim();
    if (name.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      DocumentReference docRef = await FirebaseService.createCategory({
        "name": name,
      });

      if (!context.mounted) return;

      Provider.of<CategoryProvider>(
        context,
        listen: false,
      ).addCategory({'name': name, 'id': docRef.id});

      NotificationWidget.show(
        context,
        'Category added successfully',
        type: NotificationType.success,
      );
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      NotificationWidget.show(
        context,
        'Error: ${e.toString()}',
        type: NotificationType.error,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouterName.signin, // Fixed to match router name
        (route) => false,
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng xuất không thành công: $e')));
    }
  }
}
