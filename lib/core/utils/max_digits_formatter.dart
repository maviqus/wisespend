import 'package:flutter/services.dart';

/// InputFormatter giới hạn số lượng chữ số người dùng có thể nhập.
/// - Chỉ tính các ký tự 0-9 (bỏ qua dấu phẩy, khoảng trắng nếu có sau này)
/// - Nếu vượt quá giới hạn, giữ nguyên giá trị cũ (chặn nhập thêm)
class MaxDigitsFormatter extends TextInputFormatter {
  final int maxDigits;
  const MaxDigitsFormatter(this.maxDigits);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.length > maxDigits) {
      // Chặn: trả về oldValue để không thay đổi
      return oldValue;
    }
    return newValue;
  }
}
