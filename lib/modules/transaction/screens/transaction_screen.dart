import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:wise_spend_app/core/widgets/animated_loader.dart';
import 'package:wise_spend_app/core/widgets/icon_category_widget.dart';
import 'package:wise_spend_app/core/widgets/notification_widget.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/data/providers/remove_provider.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart'; // Import the shared widget

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final List<String> _tabs = ['Tất cả', 'Thu nhập', 'Chi tiêu'];
  int _selectedTabIndex = 0;
  bool _isLoading = true;
  Map<String, List<Map<String, dynamic>>> _groupedTransactions = {};

  @override
  void initState() {
    super.initState();
    _fetchTransactions();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TotalProvider>(context, listen: false).listenTotalAll();
      }
    });
  }

  Future<void> _fetchTransactions() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseService.getExpensesCollection().get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _groupedTransactions = {};
          _isLoading = false;
        });
        return;
      }

      final Map<String, List<Map<String, dynamic>>> grouped = {};

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final dateStr = data['date'] as String? ?? '';

        if (dateStr.isEmpty) continue;

        final date = DateTime.tryParse(dateStr);
        if (date == null) continue;

        final amount = (data['amount'] ?? 0).toDouble();
        final type = data['type'] ?? (amount >= 0 ? 'Thu' : 'Chi');

        if (_selectedTabIndex == 1 && type != 'Thu' && amount < 0) {
          continue;
        } else if (_selectedTabIndex == 2 && type != 'Chi' && amount > 0) {
          continue;
        }

        final monthKey = '${_getMonthName(date.month)} ${date.year}';

        if (!grouped.containsKey(monthKey)) {
          grouped[monthKey] = [];
        }

        grouped[monthKey]!.add({...data, 'id': doc.id});
      }

      for (final month in grouped.keys) {
        grouped[month]!.sort((a, b) {
          final dateA = a['date'] as String;
          final dateB = b['date'] as String;
          return dateB.compareTo(dateA);
        });
      }

      final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

      final sortedGrouped = <String, List<Map<String, dynamic>>>{};
      for (final key in sortedKeys) {
        sortedGrouped[key] = grouped[key]!;
      }

      setState(() {
        _groupedTransactions = sortedGrouped;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      setState(() {
        _groupedTransactions = {};
        _isLoading = false;
      });
    }
  }

  String _getMonthName(int month) {
    final months = [
      'Tháng 1',
      'Tháng 2',
      'Tháng 3',
      'Tháng 4',
      'Tháng 5',
      'Tháng 6',
      'Tháng 7',
      'Tháng 8',
      'Tháng 9',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12',
    ];
    return months[month - 1];
  }

  Future<void> _deleteTransaction(
    String transactionId,
    String categoryId,
  ) async {
    if (!mounted) return;
    
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Xác nhận xóa',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa giao dịch này?',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Hủy',
                style: GoogleFonts.poppins(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Xóa', style: GoogleFonts.poppins(color: Colors.red)),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        );
      },
    );

    if (confirm == true && mounted) {
      try {
        await Provider.of<RemoveProvider>(
          context,
          listen: false,
        ).removeExpense(context, transactionId, categoryId);

        if (mounted) {
          _fetchTransactions();
        }
      } catch (e) {
        if (mounted) {
          NotificationWidget.show(
            context,
            'Lỗi: Không thể xóa giao dịch',
            type: NotificationType.error,
          );
        }
      }
    }
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    final isIncome =
        transaction['type'] == 'Thu' || (transaction['amount'] as double) > 0;

    final amount = (transaction['amount'] ?? 0).toDouble().abs();
    final category = transaction['category'] ?? '';
    final categoryId = transaction['categoryId'] ?? '';
    final transactionId = transaction['id'] ?? '';

    // Format date
    String formattedTime = '';
    String formattedDate = '';
    final dateStr = transaction['date'] as String? ?? '';
    if (dateStr.isNotEmpty) {
      final date = DateTime.tryParse(dateStr);
      if (date != null) {
        formattedTime = DateFormat('HH:mm').format(date);
        formattedDate = DateFormat('d MMMM').format(date);
      }
    }

    return Dismissible(
      key: Key(transactionId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(Icons.delete, color: Colors.white, size: 28.sp),
      ),
      confirmDismiss: (direction) async {
        await _deleteTransaction(transactionId, categoryId);
        return false;
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          leading: Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: isIncome ? Colors.blue.shade100 : const Color(0xff6DB6FE),
              borderRadius: BorderRadius.circular(15.r),
            ),
            alignment: Alignment.center,
            child: IconCategoryWidget(name: category, size: 30),
          ),
          title: Text(
            transaction['title'] ?? '',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '$formattedTime - $formattedDate',
            style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                category,
                style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
              ),
              SizedBox(height: 4.h),
              Text(
                '${isIncome ? '+' : '-'} ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(amount)}',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          onTap: () {},
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              builder: (context) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: Icon(Icons.delete_outline, color: Colors.red),
                        title: Text(
                          'Xóa giao dịch',
                          style: GoogleFonts.poppins(),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          try {
                            await Provider.of<RemoveProvider>(
                              context,
                              listen: false,
                            ).removeExpense(context, transactionId, categoryId);
                          } catch (e) {
                            if (!context.mounted) return;
                            NotificationWidget.show(
                              context,
                              e.toString(),
                              type: NotificationType.error,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00D09E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff093030)),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RouterName.home,
              (route) => false,
            );
          },
        ),
        title: Text(
          'Giao dịch',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff093030),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, RouterName.profile);
            },
            child: Container(
              margin: EdgeInsets.only(right: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
                  return ProfileAvatar(
                    key: ValueKey(DateTime.now().toString()),
                    profileUrl: profileProvider.profilePicUrl,
                    userName: profileProvider.userName,
                    radius: 20.r,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Consumer<TotalProvider>(
              builder: (context, provider, child) {
                final totalBalance = provider.totalBalance;
                provider.totalExpense.abs();
                final balanceColor = totalBalance < 0
                    ? Colors.red
                    : Colors.white;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.black87,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Tổng số dư',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: '₫',
                        decimalDigits: 0,
                      ).format(totalBalance),
                      style: GoogleFonts.poppins(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: balanceColor,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 24.h),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F7EE),
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: List.generate(_tabs.length, (index) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedTabIndex = index;
                        _fetchTransactions();
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color: _selectedTabIndex == index
                            ? const Color(0xff00D09E)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: _selectedTabIndex == index
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xff00D09E,
                                  ).withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabs[index],
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _selectedTabIndex == index
                              ? Colors.white
                              : const Color(0xff093030),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 24.h),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF1FFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: AnimatedLoader(
                isLoading: _isLoading,
                child: _groupedTransactions.isEmpty
                    ? Center(
                        child: Text(
                          'Không có giao dịch nào',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : FadeInWidget(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 20.h,
                          ),
                          itemCount: _groupedTransactions.length,
                          itemBuilder: (context, index) {
                            final monthKey = _groupedTransactions.keys
                                .elementAt(index);
                            final transactions =
                                _groupedTransactions[monthKey]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: 16.w,
                                    bottom: 12.h,
                                    top: index > 0 ? 24.h : 0,
                                  ),
                                  child: Text(
                                    monthKey,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff093030),
                                    ),
                                  ),
                                ),
                                ...transactions.map(
                                  (transaction) =>
                                      _buildTransactionItem(transaction),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RouterName.addExpenses);
        },
        backgroundColor: const Color(0xff00D09E),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const RootNavBar(currentIndex: 2),
    );
  }
}
