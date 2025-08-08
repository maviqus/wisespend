import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wise_spend_app/core/widgets/category_drop_down_widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_filled_widget.dart';
import 'package:wise_spend_app/core/widgets/button_text_widget.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/data/providers/add_expenses_provider.dart';
import 'package:intl/intl.dart';
import 'package:wise_spend_app/core/widgets/notification_widget.dart';
import 'package:wise_spend_app/core/widgets/date_picker/date_picker_widget.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart';
import 'package:wise_spend_app/core/services/firebase_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  bool _isLoaded = false;
  String _type = 'Chi';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _isLoaded = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<AddExpensesProvider>(
          context,
          listen: false,
        ).loadCategories();
      });
    }
  }

  String formatCurrency(String value) {
    if (value.isEmpty) return '';
    final number = double.tryParse(value.replaceAll(',', ''));
    if (number == null) return '';
    return NumberFormat("#,###", "vi_VN").format(number);
  }

  Future<void> _createSalaryCategoryIfNeeded(
    AddExpensesProvider provider,
  ) async {
    try {
      // Tạo category Lương mặc định
      final salaryCategory = {
        'name': 'Lương',
        'createdAt': DateTime.now().toIso8601String(),
      };
      await FirebaseService.createCategory(salaryCategory);
    } catch (e) {
      debugPrint('Error creating salary category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final addExpensesProvider = Provider.of<AddExpensesProvider>(context);

    final String? categoryIdArg =
        ModalRoute.of(context)?.settings.arguments as String?;

    void onAmountChanged(String value) {
      String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (digits.isEmpty) {
        addExpensesProvider.amountController.text = '';
        return;
      }
      final formatted = NumberFormat.currency(
        locale: "vi_VN",
        symbol: "",
        decimalDigits: 0,
      ).format(int.parse(digits));

      addExpensesProvider.amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF8),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xff00D09E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff093030)),
          onPressed: () {
            // Check if we can pop the current route
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // If we can't pop, navigate to home
              Navigator.pushReplacementNamed(context, RouterName.home);
            }
          },
        ),
        title: Text(
          _type == 'Lương'
              ? 'Thêm lương'
              : _type == 'Thu'
              ? 'Thêm khoản thu'
              : 'Thêm khoản chi',
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xff093030),
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
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
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
        ),
        toolbarHeight: 90.h,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date
                  Text(
                    'Ngày',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  DatePickerWidget(
                    initialDates: [addExpensesProvider.selectedDate],
                    callBackFuntion: (dates) {
                      if (dates.isNotEmpty && dates[0] != null) {
                        addExpensesProvider.selectedDate = dates[0]!;
                      }
                    },
                  ),
                  SizedBox(height: 20.h),

                  //Thu/Chi/Lương
                  Text(
                    'Loại',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children: [
                      ChoiceChip(
                        label: Text(
                          'Chi',
                          style: TextStyle(
                            color: _type == 'Chi' ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _type == 'Chi',
                        selectedColor: Colors.red,
                        onSelected: (selected) {
                          setState(() {
                            _type = 'Chi';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: Text(
                          'Thu',
                          style: TextStyle(
                            color: _type == 'Thu' ? Colors.white : Colors.black,
                          ),
                        ),
                        selected: _type == 'Thu',
                        selectedColor: Colors.green,
                        onSelected: (selected) {
                          setState(() {
                            _type = 'Thu';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: Text(
                          'Lương',
                          style: TextStyle(
                            color: _type == 'Lương'
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        selected: _type == 'Lương',
                        selectedColor: const Color(0xff00D09E),
                        onSelected: (selected) {
                          setState(() {
                            _type = 'Lương';
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Category - ẩn khi chọn Lương
                  if (_type != 'Lương') ...[
                    Text(
                      'Danh mục',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff093030),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: CategoryDropdownWidget(
                        categories: addExpensesProvider.categories,
                        selectedCategory: addExpensesProvider.selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            addExpensesProvider.selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  // Amount
                  Text(
                    'Số tiền (VND)',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ButtonTextFilledWidget(
                    controller: addExpensesProvider.amountController,
                    hintText: 'VND 0',
                    fillColor: const Color(0xFFE6F7EE),
                    borderRadius: 20,
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: const Color(0xff093030),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: onAmountChanged,
                  ),
                  SizedBox(height: 20.h),

                  // Expense Title
                  Text(
                    _type == 'Lương'
                        ? 'Tên khoản lương'
                        : _type == 'Thu'
                        ? 'Tên khoản thu'
                        : 'Tên khoản chi',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ButtonTextFilledWidget(
                    controller: addExpensesProvider.titleController,
                    hintText: _type == 'Lương'
                        ? 'Nhập tên khoản lương'
                        : _type == 'Thu'
                        ? 'Nhập tên khoản thu'
                        : 'Nhập tên khoản chi',
                    fillColor: const Color(0xFFE6F7EE),
                    borderRadius: 20,
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  //
                  Text(
                    'Thêm ghi chú',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  ButtonTextFilledWidget(
                    controller: addExpensesProvider.messageController,
                    hintText: 'Nhập ghi chú',
                    fillColor: const Color(0xFFE6F7EE),
                    borderRadius: 20,
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: const Color(0xff093030),
                    ),
                    height: 48.h,
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              bottom: 24.h + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: ButtonTextWidget(
              text: 'Lưu',
              color: const Color(0xff00D09E),
              radius: 24,
              onTap: () async {
                String? selectedCategoryId;

                if (_type == 'Lương') {
                  // Tìm category "Lương" trong danh sách
                  final salaryCategory = addExpensesProvider.categories
                      .firstWhere(
                        (cat) => cat['name'] == 'Lương',
                        orElse: () => {},
                      );

                  if (salaryCategory.isEmpty) {
                    // Nếu chưa có category Lương, tạo mới
                    await _createSalaryCategoryIfNeeded(addExpensesProvider);
                    // Load lại categories sau khi tạo
                    await addExpensesProvider.loadCategories();
                    final newSalaryCategory = addExpensesProvider.categories
                        .firstWhere(
                          (cat) => cat['name'] == 'Lương',
                          orElse: () => {},
                        );
                    selectedCategoryId = newSalaryCategory['id'];
                  } else {
                    selectedCategoryId = salaryCategory['id'];
                  }
                } else {
                  selectedCategoryId =
                      categoryIdArg ?? addExpensesProvider.selectedCategory;
                }

                if (selectedCategoryId != null &&
                    selectedCategoryId.isNotEmpty) {
                  // Show loading indicator
                  setState(() {
                    // Set local loading state if needed
                  });

                  // Save expense and get success result
                  bool success = await addExpensesProvider.saveExpense(
                    context,
                    selectedCategoryId,
                    type: _type == 'Lương'
                        ? 'Thu'
                        : _type, // Lương được xử lý như Thu
                  );

                  // Only navigate if save was successful and context is still valid
                  if (success && mounted) {
                    // Use pushReplacementNamed instead of pop to avoid black screen
                    Navigator.pushReplacementNamed(context, RouterName.home);
                  }
                } else {
                  if (mounted) {
                    NotificationWidget.show(
                      context,
                      _type == 'Lương'
                          ? 'Không thể tạo danh mục Lương'
                          : 'Vui lòng chọn danh mục',
                      type: NotificationType.error,
                    );
                  }
                }
              },
              height: 56.h,
            ),
          ),
        ],
      ),
      bottomNavigationBar: RootNavBar(currentIndex: 3),
    );
  }
}
