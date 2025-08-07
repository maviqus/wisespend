import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String _userName = '';
  String _userId = '';
  String _userEmail = '';
  String? _profilePicUrl;
  bool _forceAvatarRefresh = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get userName => _userName;
  String get userId => _userId;
  String get userEmail => _userEmail;
  String? get profilePicUrl => _profilePicUrl;
  bool get forceAvatarRefresh => _forceAvatarRefresh;

  ProfileProvider() {
    _getUserData();
  }

  Future<void> _getUserData() async {
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
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper method to avoid extension ambiguity
  String _capitalizeString(String input) {
    if (input.isEmpty) return input;
    return "${input[0].toUpperCase()}${input.substring(1)}";
  }

  Future<void> updateProfile({String? name, File? imageFile}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update display name if provided
        if (name != null && name.isNotEmpty) {
          await user.updateDisplayName(name);
          _userName = name;
        }

        // Upload and update profile picture if provided
        if (imageFile != null) {
          debugPrint("📷 Starting image upload...");
          
          // Create a unique filename with timestamp
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();

          // Store in user-specific folder
          final storageRef = FirebaseStorage.instance
              .ref()
              .child('users')
              .child(user.uid)
              .child('profile_$timestamp.jpg'); // Use timestamp to avoid cache

          debugPrint("⬆️ Uploading to: ${storageRef.fullPath}");

          try {
            // Upload file
            final uploadTask = storageRef.putFile(imageFile);
            final snapshot = await uploadTask;
            final downloadUrl = await snapshot.ref.getDownloadURL();
            
            debugPrint("✅ Upload successful. URL: $downloadUrl");

            // Update Firebase Auth profile
            await user.updatePhotoURL(downloadUrl);
            
            // Force reload user data
            await user.reload();
            
            // Update local state with new URL
            _profilePicUrl = downloadUrl;
            
            // Set flag to force avatar refresh
            _forceAvatarRefresh = true;
            
            debugPrint("✅ Profile updated successfully");
            
          } catch (storageError) {
            debugPrint("❌ Storage error: $storageError");
            rethrow;
          }
        }

        // Force reload the user one more time to ensure we have latest data
        await user.reload();
        final refreshedUser = FirebaseAuth.instance.currentUser;

        if (refreshedUser != null) {
          _userName = refreshedUser.displayName ?? '';
          _userId = refreshedUser.uid;
          _userEmail = refreshedUser.email ?? '';
          _profilePicUrl = refreshedUser.photoURL;

          debugPrint("✅ Final profile data:");
          debugPrint("👤 Name: $_userName");
          debugPrint("📷 Photo URL: $_profilePicUrl");
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("❌ Error updating profile: $_errorMessage");
      rethrow; // Re-throw to handle in UI
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<File?> pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
    return null;
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
}
            _userName = emailParts[0].capitalize();
          }
        }
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
