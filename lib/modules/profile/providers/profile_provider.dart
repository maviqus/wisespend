import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  String _userName = '';
  String _userId = '';
  String _userEmail = '';
  String? _profilePicUrl;
  String? _errorMessage;
  bool _isLoading = false;
  bool _forceAvatarRefresh = false;

  String get userName => _userName;
  String get userId => _userId;
  String get userEmail => _userEmail;
  String? get profilePicUrl => _profilePicUrl;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get forceAvatarRefresh => _forceAvatarRefresh;

  void resetState() {
    _userName = '';
    _userId = '';
    _userEmail = '';
    _profilePicUrl = null;
    _errorMessage = null;
    _isLoading = false;
    _forceAvatarRefresh = false;
    notifyListeners();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _userName = user.displayName ?? '';
        _userId = user.uid;
        _userEmail = user.email ?? '';
        _profilePicUrl = user.photoURL;

        // If the user has no display name, try to get the first part of their email
        if (_userName.isEmpty && _userEmail.isNotEmpty) {
          final emailParts = _userEmail.split('@');
          if (emailParts.isNotEmpty) {
            _userName = _capitalizeString(emailParts[0]);
          }
        }

        debugPrint("👤 User data loaded:");
        debugPrint("📝 Name: $_userName");
        debugPrint("🆔 ID: $_userId");
        debugPrint("📧 Email: $_userEmail");
        debugPrint("📷 Photo URL: $_profilePicUrl");
      } else {
        debugPrint("❌ No user found");
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error loading user data: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _capitalizeString(String input) {
    if (input.isEmpty) return input;
    return "${input[0].toUpperCase()}${input.substring(1)}";
  }

  Future<File?> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint("❌ Error picking image: $e");
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> updateProfile({String? name, File? imageFile}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user found');
      }

      String? newPhotoURL = _profilePicUrl;

      // Upload image if provided
      if (imageFile != null) {
        debugPrint("📤 Uploading image...");
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

        final uploadTask = await storageRef.putFile(imageFile);
        newPhotoURL = await uploadTask.ref.getDownloadURL();
        debugPrint("✅ Image uploaded: $newPhotoURL");
      }

      // Update Firebase Auth profile
      await user.updateDisplayName(name ?? _userName);
      if (newPhotoURL != null) {
        await user.updatePhotoURL(newPhotoURL);
      }

      // Reload user to get fresh data
      await user.reload();

      // Update local state
      _userName = name ?? _userName;
      _profilePicUrl = newPhotoURL;
      _forceAvatarRefresh = true;

      debugPrint("✅ Profile updated successfully");
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error updating profile: $_errorMessage");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDisplayName(String newName) async {
    if (newName.trim().isEmpty) {
      _errorMessage = 'Tên không được để trống';
      notifyListeners();
      return;
    }

    await updateProfile(name: newName.trim());
  }

  Future<void> updateProfilePicture(String photoURL) async {
    await updateProfile();
  }

  Future<void> logOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      // First reset the state to ensure UI is clean
      _userName = '';
      _userId = '';
      _userEmail = '';
      _profilePicUrl = null;
      _errorMessage = null;

      // Clear SharedPreferences
      debugPrint("🔄 Clearing SharedPreferences...");
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Clear all preferences to be thorough

      // Sign out from Firebase
      debugPrint("🔄 Signing out of Firebase...");
      await FirebaseAuth.instance.signOut();
      debugPrint("✅ Logout complete");
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Logout error: $_errorMessage");
      // Still don't throw the error so the UI can continue
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUserData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Force reload from server
        await user.reload();

        // Get fresh user instance
        final refreshedUser = FirebaseAuth.instance.currentUser;

        _userName = refreshedUser?.displayName ?? '';
        _userId = refreshedUser?.uid ?? '';
        _userEmail = refreshedUser?.email ?? '';
        _profilePicUrl = refreshedUser?.photoURL;

        // Set force refresh flag
        _forceAvatarRefresh = true;

        // If the user has no display name, try to get the first part of their email
        if (_userName.isEmpty && _userEmail.isNotEmpty) {
          final emailParts = _userEmail.split('@');
          if (emailParts.isNotEmpty) {
            _userName = _capitalizeString(emailParts[0]);
          }
        }

        debugPrint("🔄 User data refreshed:");
        debugPrint("👤 Name: $_userName");
        debugPrint("📷 Photo URL: $_profilePicUrl");
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error refreshing user data: $_errorMessage");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetForceRefresh() {
    _forceAvatarRefresh = false;
    notifyListeners();
  }
}
