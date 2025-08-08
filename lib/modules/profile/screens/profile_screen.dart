import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/core/widgets/root_navbar.widget.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/modules/profile/screens/edit_profile_screen.dart';
import 'package:wise_spend_app/routers/router_name.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart';
import 'package:wise_spend_app/data/providers/total_provider.dart'; // Add this import for TotalProvider

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Add force refresh when this screen is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).refreshUserData();
    });

    return const ProfileScreenBody();
  }
}

class ProfileScreenBody extends StatelessWidget {
  const ProfileScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF1FFF3),
      appBar: AppBar(
        backgroundColor: const Color(0xff00D09E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Check if we can safely pop or need to navigate to home
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // If we can't pop (e.g., direct navigation), go to home screen
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouterName.home,
                (route) => false,
              );
            }
          },
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Consumer<ProfileProvider>(
              builder: (context, profileProvider, _) {
                return AnimatedOpacity(
                  opacity: profileProvider.isLoading ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: ProfileAvatar(
                    // Force refresh on home screen using provider flag
                    key: ValueKey(
                      'home-${profileProvider.forceAvatarRefresh ? 'refresh' : 'normal'}-${DateTime.now().millisecondsSinceEpoch}',
                    ),
                    profileUrl: profileProvider.profilePicUrl,
                    userName: profileProvider.userName,
                    radius: 20.r,
                    forceRefresh: profileProvider.forceAvatarRefresh,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // Green top section
          Container(height: 150.h, color: const Color(0xff00D09E)),

          // White content section
          Container(
            margin: EdgeInsets.only(top: 120.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 24.h),
              child: Column(
                children: [
                  // User name and email
                  Text(
                    profileProvider.isLoading
                        ? 'Loading...'
                        : (profileProvider.userName.isNotEmpty
                              ? profileProvider.userName
                              : profileProvider.userEmail),
                    style: GoogleFonts.poppins(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff093030),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // User email if name is available
                  if (profileProvider.userName.isNotEmpty &&
                      profileProvider.userEmail.isNotEmpty)
                    Text(
                      profileProvider.userEmail,
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: Colors.grey,
                      ),
                    ),
                  SizedBox(height: 40.h),

                  // Menu items
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Edit Profile',
                    color: Colors.blue,
                    onTap: () async {
                      // Navigate to edit profile and wait for result
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<ProfileProvider>.value(
                                value: profileProvider,
                                child: EditProfileScreen(),
                              ),
                        ),
                      );

                      // If returned with success flag, refresh user data
                      if (result == true && context.mounted) {
                        // Force refresh profile data
                        await profileProvider.refreshUserData();
                      }
                    },
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.headset_mic_outlined,
                    title: 'Help',
                    color: Colors.blue,
                    onTap: () {
                      // Navigate to help screen
                    },
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    color: Colors.red,
                    onTap: () async {
                      // Don't show a dialog, as it can cause issues when navigation happens during logout
                      // Instead use a simpler approach with a loading indicator in a scaffold
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              CircularProgressIndicator(color: Colors.white),
                              SizedBox(width: 20),
                              Text('Đang đăng xuất...'),
                            ],
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      try {
                        // Get reference to profile provider
                        final profileProvider = Provider.of<ProfileProvider>(
                          context,
                          listen: false,
                        );

                        // Clear all providers that need to be reset
                        Provider.of<TotalProvider>(
                          context,
                          listen: false,
                        ).resetState();

                        // Perform logout with timeout protection
                        bool logoutComplete = false;

                        // Set a timeout to ensure we don't hang indefinitely
                        Future.delayed(const Duration(seconds: 3), () {
                          if (!logoutComplete && context.mounted) {
                            // Force navigation to login screen if logout takes too long
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              RouterName.signin,
                              (route) => false,
                            );
                          }
                        });

                        // Actually perform logout
                        await profileProvider.logOut();
                        logoutComplete = true;

                        if (!context.mounted) return;

                        // Navigate to sign in screen
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RouterName.signin,
                          (route) => false,
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Đăng xuất không thành công: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          // Profile picture - adjusted z-index by increasing the elevation with Material widget
          Positioned(
            top: 70.h,
            left: 0,
            right: 0,
            child: Center(
              child: Material(
                elevation:
                    8, // Added elevation to ensure it appears above the green section
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.transparent,
                child: AnimatedOpacity(
                  opacity: profileProvider.isLoading ? 0.5 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: ProfileAvatar(
                      profileUrl: profileProvider.profilePicUrl,
                      userName: profileProvider.userName,
                      radius: 50.r,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const RootNavBar(currentIndex: 4),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 24.sp),
                  ),
                ),
                SizedBox(width: 16.w),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16.sp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
