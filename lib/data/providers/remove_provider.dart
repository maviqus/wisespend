import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';
import 'package:wise_spend_app/core/widgets/notification_widget.dart';

class RemoveProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> removeExpense(
    BuildContext context,
    String transactionId,
    String categoryId,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseService.removeExpenseFromCategory(categoryId, transactionId);
      if (!context.mounted) return;
      Provider.of<TotalProvider>(context, listen: false).listenTotalAll();
      NotificationWidget.show(
        context,
        'Đã xóa khoản chi',
        type: NotificationType.success,
      );
    } catch (e) {
      _error = e.toString();
      if (!context.mounted) return;
      NotificationWidget.show(context, _error!, type: NotificationType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
        context,
        'Đã xóa khoản chi',
        type = NotificationType.success,
      );
    } catch (e) {
      _error = e.toString();
      if (!context.mounted) return;
      NotificationWidget.show(context, _error!, type: NotificationType.error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
