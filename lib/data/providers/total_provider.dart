import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wise_spend_app/data/services/total_service.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';

class TotalProvider extends ChangeNotifier {
  double totalBalance = 0;
  double totalExpense = 0;
  double totalIncome = 0;

  StreamSubscription? _allSubscription;
  StreamSubscription? _categorySubscription;

  bool _isTransitioning = false;
  bool get isTransitioning => _isTransitioning;

  TotalProvider() {
    _loadCache();
    listenTotalAll();
  }

  Future<void> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();
    totalBalance = prefs.getDouble('totalBalance') ?? 0;
    totalExpense = prefs.getDouble('totalExpense') ?? 0;
    totalIncome = prefs.getDouble('totalIncome') ?? 0;
    notifyListeners();
  }

  Future<void> _saveCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalBalance', totalBalance);
    await prefs.setDouble('totalExpense', totalExpense);
    await prefs.setDouble('totalIncome', totalIncome);
  }

  Future<void> listenTotalAll() async {
    _isTransitioning = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 100));

    _allSubscription?.cancel();
    _allSubscription = null;

    _allSubscription = Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) {
          return TotalService.calculateTotalAll();
        })
        .listen((result) async {
          totalBalance = result['totalBalance'] ?? 0;
          totalExpense = result['totalExpense'] ?? 0;
          totalIncome = result['totalIncome'] ?? 0;
          notifyListeners();
          await _saveCache();
        });

    _isTransitioning = false;
    notifyListeners();
  }

  void listenTotal(String categoryId) {
    _categorySubscription?.cancel();
    _categorySubscription = null;

    _categorySubscription = Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) {
          return TotalService.calculateTotalByCategory(categoryId);
        })
        .listen((result) async {
          totalBalance = result['totalBalance'] ?? 0;
          totalExpense = result['totalExpense'] ?? 0;
          notifyListeners();
          await _saveCache();
        });
  }

  Future<void> removeCategoryAndExpenses(String categoryId) async {
    final userId = FirebaseService.getCurrentUserId();
    final expensesRef = FirebaseService.firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('category')
        .doc(categoryId)
        .collection('expenses');

    final expensesSnapshot = await expensesRef.get();
    for (final doc in expensesSnapshot.docs) {
      await doc.reference.delete();
    }
    await FirebaseService.removeCategory(categoryId);
    notifyListeners();
  }

  // Add a method to reset the state when logging out
  void resetState() {
    totalBalance = 0;
    totalExpense = 0;
    totalIncome = 0;
    _isTransitioning = false;

    // Cancel any active listeners
    _unsubscribeTotalAll();

    notifyListeners();
  }

  // Add a method to unsubscribe from Firebase listeners
  void _unsubscribeTotalAll() {
    if (_allSubscription != null) {
      _allSubscription?.cancel();
      _allSubscription = null;
    }
  }

  @override
  void dispose() {
    _allSubscription?.cancel();
    _categorySubscription?.cancel();
    super.dispose();
  }

  void refresh() {
    notifyListeners();
  }
}
