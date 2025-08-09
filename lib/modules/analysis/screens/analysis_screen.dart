import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart';
import 'package:wise_spend_app/core/widgets/total_widget.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;
  bool _loading = true;
  List<Map<String, dynamic>> _chartData = [];
  int _selectedIndex = 0;
  double _displayIncome = 0;
  double _displayExpense = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      if (_tabIndex != _tabController.index) {
        setState(() {
          _tabIndex = _tabController.index;
          _selectedIndex = 0;
        });
        _fetchChartData(_tabController.index);
      }
    });
    _fetchChartData(_tabIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<TotalProvider>(context, listen: false).listenTotalAll();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchChartData(int tabIdx) async {
    setState(() {
      _loading = true;
      _chartData = [];
      _displayIncome = 0;
      _displayExpense = 0;
    });

    final now = DateTime.now();
    List<Map<String, dynamic>> chartData = [];

    try {
      final expensesSnapshot = await FirebaseService.getExpensesCollection()
          .get();

      if (expensesSnapshot.docs.isEmpty) {
        setState(() {
          _chartData = [];
          _displayIncome = 0;
          _displayExpense = 0;
          _loading = false;
        });
        return;
      }

      if (tabIdx == 0) {
        // Daily
        final days = List.generate(
          7,
          (i) => now.subtract(Duration(days: 6 - i)),
        );
        const weekdayMap = {
          1: 'T2',
          2: 'T3',
          3: 'T4',
          4: 'T5',
          5: 'T6',
          6: 'T7',
          7: 'CN',
        };
        for (final day in days) {
          final dateStr = DateFormat('yyyy-MM-dd').format(day);
          double income = 0, expense = 0;

          for (final doc in expensesSnapshot.docs) {
            final data = doc.data();
            if (data['date'] == dateStr) {
              final amt = (data['amount'] ?? 0).toDouble();
              final type = data['type'] ?? 'Chi';

              if (type == 'Thu' || amt > 0) {
                income += amt.abs();
              } else {
                expense += amt.abs();
              }
            }
          }

          chartData.add({
            'label': weekdayMap[day.weekday] ?? 't?',
            'income': income,
            'expense': expense,
          });
        }
        _selectedIndex = chartData.length - 1;
      } else if (tabIdx == 1) {
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
              final type = data['type'] ?? 'Chi';

              if (type == 'Thu' || amt > 0) {
                income += amt.abs();
              } else {
                expense += amt.abs();
              }
            }
          }
          chartData.add({
            'label': 'Tuần ${i + 1}',
            'income': income,
            'expense': expense,
          });
        }
        _selectedIndex = 3;
      } else if (tabIdx == 2) {
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
              final type = data['type'] ?? 'Chi';

              if (type == 'Thu' || amt > 0) {
                income += amt.abs();
              } else {
                expense += amt.abs();
              }
            }
          }

          chartData.add({
            'label': '${i + 1}',
            'income': income,
            'expense': expense,
          });
        }
        _selectedIndex = now.month - 1;
      } else {
        // Year
        final years = List.generate(3, (i) => now.year - 2 + i);
        for (final year in years) {
          double income = 0, expense = 0;
          for (final doc in expensesSnapshot.docs) {
            final data = doc.data();
            final dateStr = data['date'] ?? '';
            final date = DateTime.tryParse(dateStr);
            if (date != null && date.year == year) {
              final amt = (data['amount'] ?? 0).toDouble();
              final type = data['type'] ?? 'Chi';

              if (type == 'Thu' || amt > 0) {
                income += amt.abs();
              } else {
                expense += amt.abs();
              }
            }
          }
          chartData.add({
            'label': '$year',
            'income': income,
            'expense': expense,
          });
        }

        _selectedIndex = years.indexOf(now.year);
        if (_selectedIndex < 0) _selectedIndex = chartData.length - 1;
      }

      if (chartData.isEmpty) {
        _displayIncome = 0;
        _displayExpense = 0;
      } else {
        _selectedIndex = _selectedIndex.clamp(0, chartData.length - 1);
        _displayIncome = chartData[_selectedIndex]['income'];
        _displayExpense = chartData[_selectedIndex]['expense'];
      }

      setState(() {
        _chartData = chartData;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _chartData = [];
        _displayIncome = 0;
        _displayExpense = 0;
        _loading = false;
      });
    }
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
          'Phân tích',
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
              // Navigate to profile screen instead of notifications
              Navigator.pushNamed(context, RouterName.profile);
            },
            child: Container(
              margin: EdgeInsets.only(right: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
                  return ProfileAvatar(
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
            child: const TotalWidget(),
          ),

          SizedBox(height: 24.h),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 24.w),
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xffE6F7EE),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xff00D09E),
                borderRadius: BorderRadius.circular(30.r),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: const Color(0xff093030),
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
              tabs: const [
                Tab(text: 'Ngày'),
                Tab(text: 'Tuần'),
                Tab(text: 'Tháng'),
                Tab(text: 'Năm'),
              ],
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            ),
          ),

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
                    color: Colors.black.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              margin: EdgeInsets.only(top: 24.h),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildChart(),

                            SizedBox(height: 24.h),

                            Row(
                              children: [
                                Expanded(
                                  child: _buildFinanceCard(
                                    icon: Icons.arrow_outward,
                                    iconColor: const Color(0xff00D09E),
                                    title: 'Thu nhập',
                                    amount: _displayIncome,
                                  ),
                                ),
                                SizedBox(width: 16.w),

                                Expanded(
                                  child: _buildFinanceCard(
                                    icon: Icons.arrow_downward,
                                    iconColor: const Color(0xff2D9CDB),
                                    title: 'Chi tiêu',
                                    amount: _displayExpense,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const RootNavBar(currentIndex: 1),
    );
  }

  Widget _buildChart() {
    if (_chartData.isEmpty) {
      return Container(
        height: 200.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            'Không có dữ liệu',
            style: GoogleFonts.poppins(fontSize: 16.sp, color: Colors.grey),
          ),
        ),
      );
    }

    final maxY =
        (_chartData
                .map(
                  (e) => (e['income'] as double) > (e['expense'] as double)
                      ? (e['income'] as double)
                      : (e['expense'] as double),
                )
                .fold<double>(0, (p, c) => c > p ? c : p))
            .toDouble()
            .clamp(1.0, double.infinity);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Thu nhập & Chi tiêu',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: const Color(0xff093030),
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: const Color(0xffE6F7EE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff00D09E),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text('Thu', style: GoogleFonts.poppins(fontSize: 11.sp)),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: const Color(0xffE6F7EE),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff2D9CDB),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text('Chi', style: GoogleFonts.poppins(fontSize: 11.sp)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 220.h,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY * 1.2,
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions &&
                        response != null &&
                        response.spot != null) {
                      setState(() {
                        _selectedIndex = response.spot!.touchedBarGroupIndex;
                        if (_selectedIndex >= 0 &&
                            _selectedIndex < _chartData.length) {
                          _displayIncome = _chartData[_selectedIndex]['income'];
                          _displayExpense =
                              _chartData[_selectedIndex]['expense'];
                        }
                      });
                    }
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < _chartData.length) {
                          return Text(
                            _chartData[idx]['label'],
                            style: TextStyle(
                              color: idx == _selectedIndex
                                  ? const Color(0xff00D09E)
                                  : Colors.grey,
                              fontSize: 12.sp,
                              fontWeight: idx == _selectedIndex
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 45,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) {
                          return const SizedBox.shrink();
                        }

                        String text = '';
                        if (value >= 1000000) {
                          text = '${(value / 1000000).toStringAsFixed(0)}tr';
                        } else if (value >= 1000) {
                          text = '${(value / 1000).toStringAsFixed(0)}k';
                        } else {
                          text = value.toStringAsFixed(0);
                        }
                        return Text(
                          text,
                          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 5,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xffE6F7EE),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                ),
                barGroups: List.generate(_chartData.length, (index) {
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: _chartData[index]['income'],
                        width: 8.w,
                        color: const Color(0xff00D09E),
                        borderRadius: BorderRadius.circular(4.r),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: index == _selectedIndex,
                          toY: maxY * 1.2,
                          color: const Color(0xffE6F7EE),
                        ),
                      ),
                      BarChartRodData(
                        toY: _chartData[index]['expense'],
                        width: 8.w,
                        color: const Color(0xff2D9CDB),
                        borderRadius: BorderRadius.circular(4.r),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: index == _selectedIndex,
                          toY: maxY * 1.2,
                          color: const Color(0xffE6F7EE),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required double amount,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(25),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
          ),
          SizedBox(height: 4.h),
          Text(
            NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '₫',
              decimalDigits: 0,
            ).format(amount),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
