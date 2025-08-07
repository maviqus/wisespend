import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wise_spend_app/core/const/key_share_pref.dart';
import 'package:wise_spend_app/core/services/share_preferences_service.dart';

class FirebaseService {
  static late FirebaseFirestore firebaseFirestore;

  static Future<void> init() async {
    firebaseFirestore = FirebaseFirestore.instance;
  }

  static String getCurrentUserId() {
    return SharePreferencesService.getString(KeySharePref.keyUserId) ?? '';
  }

  //category
  static Future<QuerySnapshot<Map<String, dynamic>>> getAllCategory() async {
    final userId = getCurrentUserId();
    return await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('category')
        .get();
  }

  static Future<DocumentReference> createCategory(body) async {
    final userId = getCurrentUserId();
    return await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('category')
        .add(body);
  }

  static Future<DocumentReference> addCategory(
    Map<String, dynamic> data,
  ) async {
    return await FirebaseFirestore.instance.collection('category').add(data);
  }

  //create user in fireStore
  static Future<void> createUser(userId, userInfo) async {
    await firebaseFirestore.collection('users').doc(userId).set(userInfo);
    await createDefaultCategoriesForUser(userId);
  }

  static Future<void> createDefaultCategoriesForUser(String userId) async {
    final defaultCategories = [
      {'name': 'Ăn uống', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Di chuyển', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Mua sắm', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Y tế', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Giải trí', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Nhà cửa', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Hóa đơn', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Tiết kiệm', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Học tập', 'createdAt': DateTime.now().toIso8601String()},
      {'name': 'Quà tặng', 'createdAt': DateTime.now().toIso8601String()},
    ];

    final batch = firebaseFirestore.batch();

    for (final category in defaultCategories) {
      final docRef = firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('category')
          .doc();
      batch.set(docRef, category);
    }

    await batch.commit();
  }

  static Future<void> removeCategory(categoryId) async {
    final userId = getCurrentUserId();
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('category')
        .doc(categoryId)
        .delete();
  }

  // Expenses
  static CollectionReference<Map<String, dynamic>> getExpensesCollection() {
    final userId = getCurrentUserId();
    return firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('expenses');
  }

  static Future<DocumentReference<Map<String, dynamic>>> addExpense(
    Map<String, dynamic> expense,
  ) async {
    return await getExpensesCollection().add(expense);
  }

  static Future<void> addExpenseToCategory(
    String categoryId,
    Map<String, dynamic> expense,
  ) async {
    await getExpensesCollection().add({...expense, 'categoryId': categoryId});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getExpensesByCategory(
    String categoryId,
  ) {
    final userId = getCurrentUserId();
    return firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('categoryId', isEqualTo: categoryId)
        .snapshots();
  }

  static Future<void> removeExpense(String expenseId) async {
    final userId = getCurrentUserId();
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .doc(expenseId)
        .delete();
  }

  // cap nhat ex
  static Future<void> removeExpenseFromCategory(
    String categoryId,
    String expenseId,
  ) async {
    await removeExpense(expenseId);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getExpensesOfCategory(
    String categoryId, {
    List<DateTime?>? date,
  }) {
    final userId = getCurrentUserId();
    var ref = firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('expenses')
        .where('categoryId', isEqualTo: categoryId);

    if (date != null && date.isNotEmpty) {
      final dateStrings = date
          .where((d) => d != null)
          .map(
            (d) =>
                "${d!.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}",
          )
          .toList();
      if (dateStrings.length == 1) {
        ref = ref.where('date', isEqualTo: dateStrings.first);
      } else if (dateStrings.length > 1) {
        ref = ref.where('date', whereIn: dateStrings);
      }
    }

    return ref.snapshots();
  }
}
