import 'package:wise_spend_app/core/services/firebase_service.dart';

class TotalService {
  static Future<Map<String, double>> calculateTotalAll() async {
    double totalBalance = 0;
    double totalExpense = 0;
    double totalIncome = 0;

    final categoriesSnapshot = await FirebaseService.getAllCategory();
    final categories = categoriesSnapshot.docs;

    if (categories.isEmpty) {
      return {'totalBalance': 0, 'totalExpense': 0, 'totalIncome': 0};
    }

    for (final cat in categories) {
      final snapshot = await FirebaseService.getExpensesOfCategory(
        cat.id,
      ).first;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final amount = (data['amount'] ?? 0).toDouble();
        if (amount < 0) {
          totalExpense += amount;
        } else {
          totalIncome += amount;
        }
        totalBalance += amount;
      }
    }

    return {
      'totalBalance': totalBalance,
      'totalExpense': totalExpense,
      'totalIncome': totalIncome,
    };
  }

  static Future<Map<String, double>> calculateTotalByCategory(
    String categoryId,
  ) async {
    double balance = 0;
    double expense = 0;
    double income = 0;

    final snapshot = await FirebaseService.getExpensesOfCategory(
      categoryId,
    ).first;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] ?? 0).toDouble();
      if (amount < 0) {
        expense += amount;
      } else {
        income += amount;
      }
      balance += amount;
    }

    return {
      'totalBalance': balance,
      'totalExpense': expense,
      'totalIncome': income,
    };
  }
}
