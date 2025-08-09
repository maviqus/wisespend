import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/data/providers/category_provider.dart';
import 'package:wise_spend_app/modules/home/providers/home_provider.dart';
import 'package:wise_spend_app/core/services/category_customization_service.dart';

class CategoryCustomizationScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryCustomizationScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryCustomizationScreen> createState() =>
      _CategoryCustomizationScreenState();
}

class _CategoryCustomizationScreenState
    extends State<CategoryCustomizationScreen> {
  Color? _selectedColor;
  IconData? _selectedIcon;
  bool _isUploading = false;
  String _loadingMessage = 'Đang lưu tùy chỉnh...';

  // Available icons for categories
  final List<IconData> availableIcons = [
    Icons.restaurant,
    Icons.directions_bus,
    Icons.shopping_bag,
    Icons.medical_services,
    Icons.movie,
    Icons.home,
    Icons.receipt_long,
    Icons.savings,
    Icons.school,
    Icons.card_giftcard,
    Icons.sports_esports,
    Icons.fitness_center,
    Icons.pets,
    Icons.local_gas_station,
    Icons.phone,
    Icons.wifi,
    Icons.electric_bolt,
    Icons.water_drop,
    Icons.local_laundry_service,
    Icons.cut,
    Icons.spa,
    Icons.book,
    Icons.music_note,
    Icons.camera_alt,
    Icons.beach_access,
    Icons.airplanemode_active,
    Icons.local_taxi,
    Icons.train,
    Icons.directions_bike,
    Icons.local_cafe,
    Icons.local_pizza,
    Icons.icecream,
    Icons.cake,
    Icons.work,
    Icons.laptop,
    Icons.phone_android,
    Icons.headphones,
    Icons.kitchen,
    Icons.bed,
    Icons.chair,
    Icons.clean_hands,
    Icons.local_hospital,
    Icons.flight,
    Icons.hotel,
    Icons.restaurant_menu,
    Icons.coffee,
    Icons.wine_bar,
    Icons.local_bar,
    Icons.fastfood,
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    // Load existing custom color
    final existingColor = await CategoryCustomizationService.getCategoryColor(
      widget.categoryId,
    );
    if (existingColor != null) {
      setState(() {
        _selectedColor = existingColor;
      });
    }
  }

  Future<void> _saveCustomization() async {
    if (_selectedColor == null && _selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn ít nhất một tùy chọn để lưu'),
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Save color if selected
      if (_selectedColor != null) {
        setState(() {
          _loadingMessage = 'Đang lưu màu sắc...';
        });

        await CategoryCustomizationService.saveCategoryColor(
          widget.categoryId,
          _selectedColor!,
        );
      }

      setState(() {
        _loadingMessage = 'Đang cập nhật dữ liệu...';
      });

      // Update provider
      if (context.mounted) {
        final categoryProvider = Provider.of<CategoryProvider>(
          context,
          listen: false,
        );
        await categoryProvider.updateCategoryCustomization(
          widget.categoryId,
          color: _selectedColor,
          iconData: _selectedIcon,
        );

        final homeProvider = Provider.of<HomeProvider>(context, listen: false);
        await homeProvider.loadCategories();

        setState(() {
          _loadingMessage = 'Hoàn tất...';
        });

        await Future.delayed(const Duration(milliseconds: 300));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tùy chỉnh đã được lưu thành công!')),
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _resetCustomization() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: const Text('Bạn có chắc muốn đặt lại tùy chỉnh về mặc định?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();

              // Update provider
              if (context.mounted) {
                final categoryProvider = Provider.of<CategoryProvider>(
                  context,
                  listen: false,
                );
                await categoryProvider.resetCategoryCustomization(
                  widget.categoryId,
                );

                final homeProvider = Provider.of<HomeProvider>(
                  context,
                  listen: false,
                );
                await homeProvider.loadCategories();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã đặt lại về mặc định!')),
                );
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Đặt lại'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6FFF8),
        elevation: 0,
        title: Text(
          'Tùy chỉnh ${widget.categoryName}',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.black87,
        ),
        actions: [
          IconButton(
            onPressed: _resetCustomization,
            icon: const Icon(Icons.refresh),
            color: Colors.black87,
          ),
        ],
      ),
      body: _isUploading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xff00D09E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _loadingMessage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Vui lòng chờ trong giây lát',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Preview Section
                        _buildPreviewSection(),

                        SizedBox(height: 32.h),

                        // Predefined Icons Section
                        _buildSectionTitle('Biểu tượng có sẵn'),
                        SizedBox(height: 12.h),
                        _buildPredefinedIconsSection(),

                        SizedBox(height: 32.h),

                        // Color Section
                        _buildSectionTitle('Chọn màu sắc'),
                        SizedBox(height: 12.h),
                        _buildColorSection(),

                        SizedBox(height: 48.h),
                      ],
                    ),
                  ),
                ),
                // Save Button - Fixed at bottom
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: _buildSaveButton(),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildColorSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Color Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.w,
            ),
            itemCount: CategoryCustomizationService.predefinedColors.length,
            itemBuilder: (context, index) {
              final color =
                  CategoryCustomizationService.predefinedColors[index];
              final isSelected = _selectedColor == color;

              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12.r),
                    border: isSelected
                        ? Border.all(color: Colors.black87, width: 3)
                        : Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, color: Colors.white, size: 20.w)
                      : null,
                ),
              );
            },
          ),

          if (_selectedColor != null) ...[
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () => setState(() => _selectedColor = null),
              icon: const Icon(Icons.close, size: 16),
              label: const Text('Bỏ chọn màu'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_selectedColor != null || _selectedIcon != null)
            ? _saveCustomization
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff00D09E),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: Text(
          'Lưu tùy chỉnh',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            'Xem trước',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: (_selectedColor ?? const Color(0xff00D09E)).withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Icon(
              _selectedIcon ?? Icons.category,
              color: _selectedColor ?? const Color(0xff00D09E),
              size: 40.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            widget.categoryName,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredefinedIconsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
            ),
            itemCount: availableIcons.length,
            itemBuilder: (context, index) {
              final icon = availableIcons[index];
              final isSelected = _selectedIcon == icon;
              final color = _selectedColor ?? const Color(0xff00D09E);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIcon = icon;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.1)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? color : Colors.grey.shade600,
                    size: 24.sp,
                  ),
                ),
              );
            },
          ),

          if (_selectedIcon != null) ...[
            SizedBox(height: 16.h),
            TextButton.icon(
              onPressed: () => setState(() => _selectedIcon = null),
              icon: const Icon(Icons.close, size: 16),
              label: const Text('Bỏ chọn biểu tượng'),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}
