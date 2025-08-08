import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wise_spend_app/core/services/category_customization_service.dart';

class CustomCategoryIconWidget extends StatelessWidget {
  final String categoryName;
  final String? categoryId;
  final double size;
  final Color? customColor;
  final String? customIconUrl;

  const CustomCategoryIconWidget({
    super.key,
    required this.categoryName,
    this.categoryId,
    this.size = 40,
    this.customColor,
    this.customIconUrl,
  });

  static const Map<String, IconData> _iconMap = {
    'Ăn uống': Icons.restaurant,
    'Di chuyển': Icons.directions_bus,
    'Mua sắm': Icons.shopping_bag,
    'Y tế': Icons.medical_services,
    'Giải trí': Icons.movie,
    'Nhà cửa': Icons.home,
    'Hóa đơn': Icons.receipt_long,
    'Tiết kiệm': Icons.savings,
    'Học tập': Icons.school,
    'Quà tặng': Icons.card_giftcard,
    'Lương': Icons.attach_money,
  };

  static const Map<String, Color> _colorMap = {
    'Ăn uống': Color(0xFF1E88E5),
    'Di chuyển': Color(0xFF42A5F5),
    'Mua sắm': Color(0xFFEC407A),
    'Y tế': Color(0xFFEF5350),
    'Giải trí': Color(0xFF7E57C2),
    'Nhà cửa': Color(0xFF8D6E63),
    'Hóa đơn': Color(0xFF26A69A),
    'Tiết kiệm': Color(0xFF66BB6A),
    'Học tập': Color(0xFF29B6F6),
    'Quà tặng': Color(0xFFFFB74D),
    'Lương': Color(0xFF4CAF50),
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadCustomization(),
      builder: (context, snapshot) {
        Color backgroundColor;
        Widget iconChild;

        if (snapshot.hasData) {
          final data = snapshot.data!;
          backgroundColor = data['color'] as Color;
          iconChild = data['widget'] as Widget;
        } else {
          // Default while loading
          backgroundColor = customColor ?? _getDefaultColor(categoryName);
          iconChild = Icon(
            _getDefaultIcon(categoryName),
            size: size.sp * 0.6,
            color: Colors.white,
          );
        }

        return Container(
          width: size.sp,
          height: size.sp,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(child: iconChild),
        );
      },
    );
  }

  Future<Map<String, dynamic>> _loadCustomization() async {
    Color backgroundColor = customColor ?? _getDefaultColor(categoryName);
    Widget iconWidget;

    // Check for custom color
    if (categoryId != null) {
      final savedColor = await CategoryCustomizationService.getCategoryColor(
        categoryId!,
      );
      if (savedColor != null) {
        backgroundColor = savedColor;
      }
    }

    // Check for custom icon
    if (categoryId != null &&
        customIconUrl != null &&
        customIconUrl!.isNotEmpty) {
      final customIcon = await CategoryCustomizationService.getCategoryIcon(
        categoryId!,
      );

      if (customIcon != null && await customIcon.exists()) {
        iconWidget = ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: Image.file(
            customIcon,
            width: size.sp * 0.7,
            height: size.sp * 0.7,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                _getDefaultIcon(categoryName),
                size: size.sp * 0.6,
                color: Colors.white,
              );
            },
          ),
        );
      } else {
        iconWidget = Icon(
          _getDefaultIcon(categoryName),
          size: size.sp * 0.6,
          color: Colors.white,
        );
      }
    } else {
      iconWidget = Icon(
        _getDefaultIcon(categoryName),
        size: size.sp * 0.6,
        color: Colors.white,
      );
    }

    return {'color': backgroundColor, 'widget': iconWidget};
  }

  static Color _getDefaultColor(String categoryName) {
    return _colorMap[categoryName] ?? const Color(0xFF78909C);
  }

  static IconData _getDefaultIcon(String categoryName) {
    return _iconMap[categoryName] ?? Icons.category;
  }
}
