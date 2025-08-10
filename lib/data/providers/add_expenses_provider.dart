import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/core/widgets/notification_widget.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';

class AddExpensesProvider extends ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategory;
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  List<Map<String, dynamic>> categories = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DateTime get selectedDate => _selectedDate;
  set selectedDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  String? get selectedCategory => _selectedCategory;
  set selectedCategory(String? value) {
    _selectedCategory = value;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    final snapshot = await FirebaseService.getAllCategory();
    categories = snapshot.docs
        .map((doc) => {...doc.data(), 'id': doc.id})
        .toList();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      selectedDate = picked;
      notifyListeners();
    }
  }

  Future<bool> saveExpense(
    BuildContext context,
    String categoryId, {
    String type = 'Chi',
  }) async {
    if (!context.mounted) return false;

    if (categoryId.isEmpty ||
        amountController.text.isEmpty ||
        titleController.text.isEmpty) {
      NotificationWidget.show(
        context,
        'Vui lòng điền đầy đủ các trường bắt buộc',
        type: NotificationType.error,
      );
      return false;
    }

    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {},
    );
    final categoryName = category['name'] ?? '';

    // Chuẩn hóa chuỗi số
    final rawDigits = amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    // Giới hạn độ dài đồng bộ với input (12 digits)
    const int kMaxAmountDigits = 12;
    if (rawDigits.length > kMaxAmountDigits) {
      NotificationWidget.show(
        context,
        'Số tiền quá lớn (tối đa $kMaxAmountDigits chữ số)',
        type: NotificationType.error,
      );
      return false;
    }
    double amount = double.tryParse(rawDigits) ?? 0;
    if (type == 'Chi') amount = -amount;

    final expense = {
      'categoryId': categoryId,
      'category': categoryName,
      'amount': amount,
      'type': type,
      'title': titleController.text,
      'message': messageController.text,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
      'createdAt': DateTime.now(),
    };

    try {
      await FirebaseService.addExpenseToCategory(categoryId, expense);
      if (!context.mounted) return false;
      Provider.of<TotalProvider>(context, listen: false).listenTotalAll();

      String message;
      if (type == 'Thu') {
        message = 'Lưu khoản thu thành công';
      } else if (expense['category'] == 'Lương') {
        message = 'Lưu lương thành công';
      } else {
        message = 'Lưu khoản chi thành công';
      }

      NotificationWidget.show(context, message, type: NotificationType.success);

      // Reset all fields including date
      amountController.clear();
      titleController.clear();
      messageController.clear();
      _selectedDate = DateTime.now(); // Reset về ngày hiện tại
      _selectedCategory = null; // Reset category đã chọn
      notifyListeners();
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      NotificationWidget.show(
        context,
        e.toString(),
        type: NotificationType.error,
      );
      return false;
    }
  }
}
