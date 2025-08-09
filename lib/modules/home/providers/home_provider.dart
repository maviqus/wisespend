import 'package:flutter/material.dart';
import 'package:wise_spend_app/core/widgets/notification_widget.dart';
import 'package:wise_spend_app/data/services/category_service.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';

class HomeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String getGreetingByTime() {
    final hour = DateTime.now().hour;
    if (hour >= 6 && hour < 12) {
      return "Chúc bạn buổi sáng vui vẻ";
    } else if (hour >= 12 && hour < 14) {
      return "Chúc bạn buổi trưa vui vẻ";
    } else if (hour >= 14 && hour < 18) {
      return "Chúc bạn buổi chiều vui vẻ";
    } else {
      return "Chúc bạn buổi tối vui vẻ";
    }
  }

  final List<Map<String, dynamic>> defaultCategories = [
    {'name': 'Ăn uống', 'icon': Icons.restaurant, 'color': Color(0xFF1E88E5)},
    {
      'name': 'Di chuyển',
      'icon': Icons.directions_bus,
      'color': Color(0xFF42A5F5),
    },
    {'name': 'Mua sắm', 'icon': Icons.shopping_bag, 'color': Color(0xFFEC407A)},
    {
      'name': 'Y tế',
      'icon': Icons.medical_services,
      'color': Color(0xFFEF5350),
    },
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
  ];

  HomeProvider() {
    loadCategories();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedCategories =
          await CategoryService.getAllCategoriesForCurrentUser();

      if (loadedCategories.isEmpty) {
        await createDefaultCategories();
        final newCategories =
            await CategoryService.getAllCategoriesForCurrentUser();
        _categories = newCategories;
      } else {
        _categories = loadedCategories;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createDefaultCategories() async {
    for (final category in defaultCategories) {
      await CategoryService.createCategory({
        'name': category['name'],
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  Future<Map<String, dynamic>?> addCategory(
    BuildContext context,
    String categoryName,
  ) async {
    if (categoryName.trim().isEmpty) {
      _errorMessage = 'Tên danh mục không được để trống';
      notifyListeners();
      return null;
    }

    try {
      final docRef = await CategoryService.createCategory({
        'name': categoryName,
        'createdAt': DateTime.now().toIso8601String(),
      });

      // Create category data with the generated ID
      final categoryData = {
        'id': docRef.id,
        'name': categoryName,
        'createdAt': DateTime.now().toIso8601String(),
      };

      // Add to local state immediately for instant UI update
      _categories.add(categoryData);
      // DEBUG: Added category to local state
      notifyListeners();

      if (context.mounted) {
        NotificationWidget.show(
          context,
          'Thêm danh mục thành công',
          type: NotificationType.success,
        );
      }

      return categoryData;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();

      if (context.mounted) {
        NotificationWidget.show(
          context,
          'Lỗi: $_errorMessage',
          type: NotificationType.error,
        );
      }
      return null;
    }
  }

  Future<void> deleteCategory(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) async {
    // Store backup of categories in case of error
    final originalCategories = List<Map<String, dynamic>>.from(_categories);

    try {
      // Remove from local state first for instant UI update
      _categories.removeWhere((cat) => cat['id'] == categoryId);
      print(
        'DEBUG: Removed category from local state. Total categories: ${_categories.length}',
      );
      print('DEBUG: Categories: ${_categories.map((c) => c['name']).toList()}');
      notifyListeners();

      // Then remove from Firebase
      await CategoryService.removeCategoryAndExpenses(categoryId);

      if (context.mounted) {
        NotificationWidget.show(
          context,
          'Đã xóa danh mục "$categoryName"',
          type: NotificationType.success,
        );
      }
    } catch (e) {
      // If error occurs, restore the original state
      _categories = originalCategories;
      _errorMessage = e.toString();
      notifyListeners();

      if (context.mounted) {
        NotificationWidget.show(
          context,
          'Lỗi: $_errorMessage',
          type: NotificationType.error,
        );
      }
    }
  }

  Future<void> restoreDefaultCategories(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseService.createDefaultCategoriesForUser(
        FirebaseService.getCurrentUserId(),
      );

      // Reload categories to get the fresh data from Firebase
      await loadCategories();

      if (context.mounted) {
        NotificationWidget.show(
          context,
          'Đã khôi phục danh mục mặc định',
          type: NotificationType.success,
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        NotificationWidget.show(
          context,
          'Lỗi: $_errorMessage',
          type: NotificationType.error,
        );
      }
    }
  }
}
