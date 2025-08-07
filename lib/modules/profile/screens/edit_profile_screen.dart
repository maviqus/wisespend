import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wise_spend_app/modules/profile/providers/profile_provider.dart';
import 'package:wise_spend_app/core/widgets/profile_avatar_widget.dart'; // Import the shared widget

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isUpdating = false;
  File? _selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profileProvider = Provider.of<ProfileProvider>(
      context,
      listen: false,
    );
    _nameController.text = profileProvider.userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );

      final File? pickedImage = await profileProvider.pickProfileImage();

      if (pickedImage != null) {
        setState(() {
          _selectedImage = pickedImage;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi chọn ảnh: $e')));
      }
    }
  }

  Future<void> _updateProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tên không được để trống')));
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    try {
      final profileProvider = Provider.of<ProfileProvider>(
        context,
        listen: false,
      );

      debugPrint("📷 Starting profile update...");
      if (_selectedImage != null) {
        debugPrint("📷 Image selected: ${_selectedImage!.path}");
      }

      // Clear image cache before update
      imageCache.clear();
      imageCache.clearLiveImages();

      // Update profile
      await profileProvider.updateProfile(
        name: _nameController.text.trim(),
        imageFile: _selectedImage,
      );

      if (!mounted) return;

      // Force refresh user data again
      await profileProvider.refreshUserData();

      // Clear cache again after update
      imageCache.clear();
      imageCache.clearLiveImages();

      // Clear selected image
      setState(() {
        _selectedImage = null;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cập nhật hồ sơ thành công'),
          backgroundColor: Colors.green,
        ),
      );

      // Wait a bit to ensure everything is updated
      await Future.delayed(Duration(milliseconds: 500));

      // Navigate back with success flag
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi cập nhật: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

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
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit My Profile',
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
            child: ProfileAvatar(
              profileUrl: profileProvider.profilePicUrl,
              userName: profileProvider.userName,
              radius: 20.r,
            ),
          ),
        ],
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(height: 150.h, color: const Color(0xff00D09E)),

          Container(
            margin: EdgeInsets.only(top: 120.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24.w, 80.h, 24.w, 24.h),
              child: Column(
                children: [
                  Text(
                    profileProvider.userName.isNotEmpty
                        ? profileProvider.userName
                        : profileProvider.userEmail,
                    style: GoogleFonts.poppins(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff093030),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Account Settings',
                      style: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff093030),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Username field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Username',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xffE6F7EE),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 16.h,
                        horizontal: 16.w,
                      ),
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      color: const Color(0xff093030),
                    ),
                  ),

                  SizedBox(height: 100.h),

                  SizedBox(
                    width: double.infinity,
                    height: 56.h,
                    child: ElevatedButton(
                      onPressed: _isUpdating ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00D09E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: _isUpdating
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Update Profile',
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Profile picture section with force refresh
          Positioned(
            top: 70.h,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: Colors.white,
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(47.r),
                              child: Image.file(
                                _selectedImage!,
                                width: 94.r,
                                height: 94.r,
                                fit: BoxFit.cover,
                              ),
                            )
                          : ProfileAvatar(
                              // Force refresh when editing
                              key: ValueKey(
                                'edit-${DateTime.now().millisecondsSinceEpoch}',
                              ),
                              profileUrl: profileProvider.profilePicUrl,
                              userName: profileProvider.userName,
                              radius: 47.r,
                              forceRefresh: true, // Add force refresh
                            ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xff00D09E),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
