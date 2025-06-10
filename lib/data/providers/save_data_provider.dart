import 'package:flutter/material.dart';
import '../services/data_fire_base_service.dart';

class SaveDataProvider extends ChangeNotifier {
  final DataFirebaseService _service = DataFirebaseService();
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> saveExpense(Map<String, dynamic> expense) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _service.addExpense(expense);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }
}
