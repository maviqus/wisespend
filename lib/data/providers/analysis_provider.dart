import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';

class AnalysisProvider extends ChangeNotifier {
  int tabIndex = 0;
  bool loading = true;
  List<Map<String, dynamic>> chartData = [];
  double totalIncome = 0;
  double totalExpense = 0;

  Future<void> fetchChartData() async {
    loading = true;
    notifyListeners();

    final now = DateTime.now();
    List<Map<String, dynamic>> chartDataTmp = [];
    double totalIncomeTmp = 0;
    double totalExpenseTmp = 0;

    final expensesSnapshot = await FirebaseService.getExpensesCollection()
        .where(
          'date',
          isLessThanOrEqualTo: DateFormat('yyyy-MM-dd').format(now),
        )
        .get();

    if (tabIndex == 0) {
      // Daily
      final days = List.generate(7, (i) => now.subtract(Duration(days: 6 - i)));
      for (final day in days) {
        final dateStr = DateFormat('yyyy-MM-dd').format(day);
        double income = 0, expense = 0;
        for (final doc in expensesSnapshot.docs) {
          final data = doc.data();
          if (data['date'] == dateStr) {
            final amt = (data['amount'] ?? 0).toDouble();
            if (amt >= 0) {
              income += amt;
            } else {
              expense += amt.abs();
            }
          }
        }
        chartDataTmp.add({
          'label': DateFormat('E').format(day),
          'income': income,
          'expense': expense,
        });
        totalIncomeTmp += income;
        totalExpenseTmp += expense;
      }
    } else if (tabIndex == 1) {
      // Weekly
      final weeks = List.generate(4, (i) {
        final start = now.subtract(
          Duration(days: now.weekday - 1 + (3 - i) * 7),
        );
        final end = start.add(Duration(days: 6));
        return {'start': start, 'end': end};
      });
      for (int i = 0; i < weeks.length; i++) {
        final week = weeks[i];
        double income = 0, expense = 0;
        for (final doc in expensesSnapshot.docs) {
          final data = doc.data();
          final dateStr = data['date'] ?? '';
          final date = DateTime.tryParse(dateStr);
          if (date != null &&
              !date.isBefore(week['start'] as DateTime) &&
              !date.isAfter(week['end'] as DateTime)) {
            final amt = (data['amount'] ?? 0).toDouble();
            if (amt >= 0) {
              income += amt;
            } else {
              expense += amt.abs();
            }
          }
        }
        chartDataTmp.add({
          'label': 'Tuần ${i + 1}',
          'income': income,
          'expense': expense,
        });
        totalIncomeTmp += income;
        totalExpenseTmp += expense;
      }
    } else if (tabIndex == 2) {
      // Monthly
      final months = List.generate(12, (i) => DateTime(now.year, i + 1, 1));
      for (int i = 0; i < months.length; i++) {
        final month = months[i];
        double income = 0, expense = 0;
        for (final doc in expensesSnapshot.docs) {
          final data = doc.data();
          final dateStr = data['date'] ?? '';
          final parsedDate = DateTime.tryParse(dateStr);
          if (parsedDate != null &&
              parsedDate.year == month.year &&
              parsedDate.month == month.month) {
            final amt = (data['amount'] ?? 0).toDouble();
            if (amt >= 0) {
              income += amt;
            } else {
              expense += amt.abs();
            }
          }
        }
        chartDataTmp.add({
          'label': '${i + 1}',
          'income': income,
          'expense': expense,
        });
        totalIncomeTmp += income;
        totalExpenseTmp += expense;
      }
    } else {
      // Year: 3 năm
      final years = List.generate(3, (i) => now.year - 2 + i);
      for (final year in years) {
        double income = 0, expense = 0;
        for (final doc in expensesSnapshot.docs) {
          final data = doc.data();
          final dateStr = data['date'] ?? '';
          final date = DateTime.tryParse(dateStr);
          if (date != null && date.year == year) {
            final amt = (data['amount'] ?? 0).toDouble();
            if (amt >= 0) {
              income += amt;
            } else {
              expense += amt.abs();
            }
          }
        }
        chartDataTmp.add({
          'label': '$year',
          'income': income,
          'expense': expense,
        });
        totalIncomeTmp += income;
        totalExpenseTmp += expense;
      }
    }

    chartData = chartDataTmp;
    totalIncome = totalIncomeTmp;
    totalExpense = totalExpenseTmp;
    loading = false;
    notifyListeners();
  }

  void setTabIndex(int idx) {
    tabIndex = idx;
    fetchChartData();
    notifyListeners();
  }
}
