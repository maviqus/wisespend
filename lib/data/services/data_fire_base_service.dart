import 'package:cloud_firestore/cloud_firestore.dart';

class DataFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm
  Future<void> addExpense(Map<String, dynamic> expense) async {
    try {
      await _firestore.collection('expenses').add({
        ...expense,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Could not add expense');
    }
  }

  // Lấy
  Stream<QuerySnapshot> getExpensesByCategory(String category) {
    return _firestore
        .collection('expenses')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // Cập nhật
  Future<void> updateExpense(String id, Map<String, dynamic> expense) async {
    try {
      await _firestore.collection('expenses').doc(id).update(expense);
    } catch (e) {
      throw Exception('Could not update expense');
    }
  }

  // Xóa
  Future<void> deleteExpense(String id) async {
    try {
      await _firestore.collection('expenses').doc(id).delete();
    } catch (e) {
      throw Exception('Could not delete expense');
    }
  }
}
