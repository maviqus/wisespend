import 'package:flutter/material.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';
import 'package:provider/provider.dart';

class CategoryProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> defaultCategories = [
    {'name': 'Giải trí', 'icon': Icons.movie, 'color': Color(0xFF7E57C2)},
    {'name': 'Nhà cửa', 'icon': Icons.home, 'color': Color(0xFF8D6E63)},
    {'name': 'Hóa đơn', 'icon': Icons.receipt_long, 'color': Color(0xFF26A69A)},
    {'name': 'Tiết kiệm', 'icon': Icons.savings, 'color': Color(0xFF66BB6A)},
    {'name': 'Học tập', 'icon': Icons.school, 'color': Color(0xFF29B6F6)},
    {
      'name': 'Quà tặng',
      'icon': Icons.card_giftcard,
      'color': Color(0xFFFFB74D),
    },
    {'name': 'Lương', 'icon': Icons.attach_money, 'color': Color(0xFF4CAF50)},
  ];

  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  String? _error;
  List<DateTime?> _selectedDate = [];
  bool _isLoadingExpenses = false;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DateTime?> get selectedDate => _selectedDate;
  bool get isLoadingExpenses => _isLoadingExpenses;

  set selectedDate(List<DateTime?> value) {
    _selectedDate = value;
    notifyListeners();
  }

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    try {
      var res = await FirebaseService.getAllCategory();
      _categories = res.docs
          .map((doc) => {...doc.data(), 'id': doc.id})
          .toList();

      if (_categories.isEmpty) {
        await createDefaultCategories();
        res = await FirebaseService.getAllCategory();
        _categories = res.docs
            .map((doc) => {...doc.data(), 'id': doc.id})
            .toList();
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createDefaultCategories() async {
    await Future.delayed(Duration(milliseconds: 500));

    for (final category in defaultCategories) {
      try {
        final existingCategories = await FirebaseService.getAllCategory();
        final alreadyExists = existingCategories.docs.any(
          (doc) => doc.data()['name'] == category['name'],
        );

        if (!alreadyExists) {
          await FirebaseService.createCategory({
            'name': category['name'],
            'createdAt': DateTime.now().toIso8601String(),
          });
          await Future.delayed(Duration(milliseconds: 100));
        }
      } catch (e) {
        _error = e.toString();
      }
    }
  }

  Future<void> addCategory(Map<String, dynamic> category) async {
    try {
      final docRef = await FirebaseService.createCategory(category);
      _categories.add({...category, 'id': docRef.id});
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> removeCategory(BuildContext context, String categoryId) async {
    try {
      await Provider.of<TotalProvider>(
        context,
        listen: false,
      ).removeCategoryAndExpenses(categoryId);
      _categories.removeWhere((cat) => cat['id'] == categoryId);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> restoreDefaultCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseService.createDefaultCategoriesForUser(
        FirebaseService.getCurrentUserId(),
      );
      await init();
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectDate(List<DateTime?> date) {
    _selectedDate = date;
    notifyListeners();
  }

  void resetData() {
    _categories.clear();
    notifyListeners();
  }

  void setLoadingExpenses(bool value) {
    _isLoadingExpenses = value;
    notifyListeners();
  }

  Future<void> updateCategoryCustomization(
    String categoryId, {
    String? iconUrl,
    Color? color,
    IconData? iconData,
  }) async {
    try {
      Map<String, dynamic> updateData = {};

      if (iconUrl != null) {
        updateData['customIconUrl'] = iconUrl;
      }

      if (color != null) {
        updateData['customColor'] = color.value.toRadixString(16).padLeft(8, '0');
      }

      if (iconData != null) {
        updateData['customIconCode'] = iconData.codePoint;
      }

      await FirebaseService.updateCategory(categoryId, updateData);

      // Update local categories
      final categoryIndex = _categories.indexWhere(
        (cat) => cat['id'] == categoryId,
      );
      if (categoryIndex != -1) {
        _categories[categoryIndex] = {
          ..._categories[categoryIndex],
          ...updateData,
        };
        notifyListeners();
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resetCategoryCustomization(String categoryId) async {
    try {
      await FirebaseService.updateCategory(categoryId, {
        'customIconUrl': null,
        'customColor': null,
      });

      // Update local categories
      final categoryIndex = _categories.indexWhere(
        (cat) => cat['id'] == categoryId,
      );
      if (categoryIndex != -1) {
        _categories[categoryIndex].remove('customIconUrl');
        _categories[categoryIndex].remove('customColor');
        notifyListeners();
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
