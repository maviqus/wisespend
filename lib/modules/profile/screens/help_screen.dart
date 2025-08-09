import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(
          'Liên hệ hỗ trợ',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.phone, color: Color(0xff00D09E)),
                SizedBox(width: 8.w),
                const Text('0908 374 477'),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                const Icon(Icons.email_outlined, color: Color(0xff00D09E)),
                SizedBox(width: 8.w),
                const Expanded(child: Text('bachnguyn.work@gmail.com')),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Hỗ trợ',
          style: GoogleFonts.poppins(
            color: const Color(0xff093030),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xffF1FFF3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.r),
                  topRight: Radius.circular(40.r),
                ),
              ),
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bạn cần giúp gì?',
                    style: GoogleFonts.poppins(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Chúng tôi luôn sẵn sàng hỗ trợ bạn trong việc quản lý chi tiêu, phản hồi lỗi hoặc đề xuất tính năng mới.',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xff00D09E).withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.support_agent,
                        color: Color(0xff00D09E),
                      ),
                    ),
                    title: Text(
                      'Liên hệ hỗ trợ',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Nhấn để xem email & số điện thoại',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    onTap: () => _showContactDialog(context),
                  ),
                  Divider(height: 32.h),

                  SizedBox(height: 24.h),
                  Center(
                    child: Text(
                      'Phiên bản 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
