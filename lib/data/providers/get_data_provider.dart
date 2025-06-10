import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/data_fire_base_service.dart';

class GetDataProvider extends ChangeNotifier {
  final DataFirebaseService _service = DataFirebaseService();
  final List<Map<String, dynamic>> _expenses = [];
  final bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get expenses => _expenses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Stream<QuerySnapshot> getExpensesByCategory(String category) {
    return _service.getExpensesByCategory(category);
  }
}
