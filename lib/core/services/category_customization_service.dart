import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class CategoryCustomizationService {
  static const String _localCachePrefix = 'category_icon_';
  static const String _colorPrefix = 'category_color_';
  static const int _maxImageSize = 512;

  // Get current user ID
  static String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error picking image: $e');
      return null;
    }
  }

  // Resize and compress image
  static Future<Uint8List> _resizeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: _maxImageSize,
      targetHeight: _maxImageSize,
    );
    final frame = await codec.getNextFrame();
    final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  // Upload category icon to Firebase
  static Future<String?> uploadCategoryIcon(
    String categoryId,
    File imageFile,
  ) async {
    if (_currentUserId == null) return null;

    try {
      final resizedImageData = await _resizeImage(imageFile);

      final ref = FirebaseStorage.instance
          .ref()
          .child('category_icons')
          .child(_currentUserId!)
          .child('$categoryId.png');

      final uploadTask = ref.putData(resizedImageData);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();

      // Save to local cache
      await _saveToLocalCache(categoryId, resizedImageData);

      debugPrint('✅ Category icon uploaded: $url');
      return url;
    } catch (e) {
      debugPrint('❌ Error uploading category icon: $e');
      return null;
    }
  }

  // Save image data to local cache
  static Future<void> _saveToLocalCache(
    String categoryId,
    Uint8List imageData,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_localCachePrefix$categoryId.png');
      await file.writeAsBytes(imageData);
    } catch (e) {
      debugPrint('❌ Error saving to local cache: $e');
    }
  }

  // Get category icon (try local first, then Firebase)
  static Future<File?> getCategoryIcon(String categoryId) async {
    if (_currentUserId == null) return null;

    try {
      // Check local cache first
      final directory = await getApplicationDocumentsDirectory();
      final localFile = File(
        '${directory.path}/$_localCachePrefix$categoryId.png',
      );

      if (await localFile.exists()) {
        return localFile;
      }

      // Try to download from Firebase
      final ref = FirebaseStorage.instance
          .ref()
          .child('category_icons')
          .child(_currentUserId!)
          .child('$categoryId.png');

      try {
        final data = await ref.getData();
        if (data != null) {
          await localFile.writeAsBytes(data);
          return localFile;
        }
      } catch (e) {
        // File doesn't exist on Firebase, that's ok
      }

      return null;
    } catch (e) {
      debugPrint('❌ Error getting category icon: $e');
      return null;
    }
  }

  // Save category color
  static Future<void> saveCategoryColor(String categoryId, Color color) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        '$_colorPrefix$categoryId',
        color.value.toRadixString(16).padLeft(8, '0'),
      );
    } catch (e) {
      debugPrint('❌ Error saving category color: $e');
      rethrow;
    }
  }

  static Future<Color?> getCategoryColor(String categoryId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final colorString = prefs.getString('$_colorPrefix$categoryId');
      if (colorString != null) {
        final colorValue = int.parse(colorString, radix: 16);
        return Color(colorValue);
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getting category color: $e');
      return null;
    }
  }

  // Predefined colors
  static const List<Color> predefinedColors = [
    Color(0xFF1E88E5), // Blue
    Color(0xFF42A5F5), // Light Blue
    Color(0xFFEC407A), // Pink
    Color(0xFFEF5350), // Red
    Color(0xFF7E57C2), // Purple
    Color(0xFF8D6E63), // Brown
    Color(0xFF26A69A), // Teal
    Color(0xFF66BB6A), // Green
    Color(0xFF29B6F6), // Cyan
    Color(0xFFFFB74D), // Orange
    Color(0xFF4CAF50), // Dark Green
    Color(0xFFF06292), // Light Pink
    Color(0xFF9C27B0), // Dark Purple
    Color(0xFF2196F3), // Material Blue
    Color(0xFFFF9800), // Amber
    Color(0xFF795548), // Deep Brown
  ];
}
