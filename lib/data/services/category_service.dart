import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';

class CategoryService {
  // Lấy tất cả danh mục từ collection "category" (legacy)
  static Future<List<Map<String, dynamic>>> getAllCategory() async {
    try {
      var res = await FirebaseFirestore.instance.collection('category').get();
      return res.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      return [];
    }
  }

  // Lấy tất cả danh mục của người dùng hiện tại
  static Future<List<Map<String, dynamic>>>
  getAllCategoriesForCurrentUser() async {
    try {
      final snapshot = await FirebaseService.getAllCategory();
      return snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList();
    } catch (e) {
      throw Exception('Không thể tải danh mục: $e');
    }
  }

  // Tạo danh mục mới
  static Future<DocumentReference> createCategory(
    Map<String, dynamic> categoryData,
  ) async {
    try {
      return await FirebaseService.createCategory(categoryData);
    } catch (e) {
      throw Exception('Không thể tạo danh mục: $e');
    }
  }

  // Xóa danh mục và tất cả chi tiêu của danh mục đó
  static Future<void> removeCategoryAndExpenses(String categoryId) async {
    try {
      final userId = FirebaseService.getCurrentUserId();

      // Lấy tất cả chi tiêu của danh mục
      final expensesSnapshot = await FirebaseService.getExpensesCollection()
          .where('categoryId', isEqualTo: categoryId)
          .get();

      // Xóa từng chi tiêu
      final batch = FirebaseService.firebaseFirestore.batch();
      for (var doc in expensesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Xóa danh mục
      batch.delete(
        FirebaseService.firebaseFirestore
            .collection('users')
            .doc(userId)
            .collection('category')
            .doc(categoryId),
      );

      // Thực hiện batch
      await batch.commit();
    } catch (e) {
      throw Exception('Không thể xóa danh mục: $e');
    }
  }
}
