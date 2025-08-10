import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/modules/authenticator/providers/password_reset_code_provider.dart';

class PasswordResetCodeScreen extends StatefulWidget {
  const PasswordResetCodeScreen({super.key});

  @override
  State<PasswordResetCodeScreen> createState() =>
      _PasswordResetCodeScreenState();
}

class _PasswordResetCodeScreenState extends State<PasswordResetCodeScreen> {
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác minh mã', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xff00D09E),
      ),
      body: Consumer<PasswordResetCodeProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nhập mã được gửi tới email của bạn',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Mã xác minh (6 số)',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                ),
                SizedBox(height: 8.h),
                if (!provider.codeVerified)
                  ElevatedButton(
                    onPressed: provider.verifying
                        ? null
                        : () async {
                            final ok = await provider.verifyCode(
                              _codeController.text.trim(),
                            );
                            if (ok && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Mã hợp lệ')),
                              );
                            } else if (mounted && provider.error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(provider.error!)),
                              );
                            }
                          },
                    child: provider.verifying
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Xác minh mã'),
                  ),
                if (provider.codeVerified) ...[
                  SizedBox(height: 24.h),
                  Text(
                    'Nhập mật khẩu mới',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu mới',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 12.h),
                  TextField(
                    controller: _confirmController,
                    decoration: const InputDecoration(
                      labelText: 'Xác nhận mật khẩu',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () async {
                      if (_passwordController.text != _confirmController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Mật khẩu không khớp')),
                        );
                        return;
                      }
                      final ok = await provider.updatePassword(
                        _passwordController.text.trim(),
                      );
                      if (ok && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đổi mật khẩu thành công'),
                          ),
                        );
                        Navigator.pop(context);
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(provider.error ?? 'Lỗi')),
                        );
                      }
                    },
                    child: const Text('Đặt lại mật khẩu'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
