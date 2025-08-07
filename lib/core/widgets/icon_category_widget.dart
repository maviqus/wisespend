import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconCategoryWidget extends StatelessWidget {
  final String name;
  final double size;
  final Color? color;

  const IconCategoryWidget({
    super.key,
    required this.name,
    this.size = 40,
    this.color,
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
    // Replace Icon with Container containing Icon to create square background
    return Container(
      width: size.sp,
      height: size.sp,
      decoration: BoxDecoration(
        color: color ?? getCategoryColor(name),
        borderRadius: BorderRadius.circular(8.r), // Slightly rounded corners
      ),
      child: Center(
        child: Icon(
          getCategoryIcon(name),
          size: size.sp * 0.6, // Slightly smaller icon
          color: Colors.white, // Always white icons
        ),
      ),
    );
  }

  static Color getCategoryColor(String categoryName) {
    return _colorMap[categoryName] ?? const Color(0xFF78909C);
  }

  static IconData getCategoryIcon(String categoryName) {
    return _iconMap[categoryName] ?? Icons.category;
  }
}
