import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileAvatar extends StatelessWidget {
  final String? profileUrl;
  final String userName;
  final double radius;
  final bool forceRefresh;

  const ProfileAvatar({
    super.key,
    required this.profileUrl,
    required this.userName,
    this.radius = 20,
    this.forceRefresh = false,
  });

  @override
  Widget build(BuildContext context) {
    // Always get the latest photo URL directly from Firebase Auth
    final currentUser = FirebaseAuth.instance.currentUser;
    final latestPhotoUrl = currentUser?.photoURL;

    // Use the latest URL with preference over the provided URL
    final effectiveUrl = latestPhotoUrl ?? profileUrl;

    // Force clear image cache if needed
    if (forceRefresh) {
      imageCache.clear();
      imageCache.clearLiveImages();
    }

    debugPrint("🖼️ ProfileAvatar using URL: $effectiveUrl");

    if (effectiveUrl != null && effectiveUrl.isNotEmpty) {
      // Create a unique cache key that changes when forceRefresh is true
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cacheKey = ValueKey(
        '$effectiveUrl-$timestamp-${forceRefresh ? 'force' : 'normal'}',
      );

      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.grey.shade200,
        key: cacheKey,
        child: ClipOval(
          child: Image.network(
            effectiveUrl,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            // Force disable caching completely
            cacheWidth: null,
            cacheHeight: null,
            // Add cache busting headers
            headers: {
              "Cache-Control": "no-cache, no-store, must-revalidate",
              "Pragma": "no-cache",
              "Expires": "0",
              "X-Timestamp": timestamp.toString(),
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                      : null,
                  color: const Color(0xff00D09E),
                  strokeWidth: 2,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              debugPrint("❌ Error loading avatar: $error");
              return _buildFallbackAvatar();
            },
            // Force reload by adding timestamp to URL
            filterQuality: FilterQuality.medium,
          ),
        ),
      );
    } else {
      return _buildFallbackAvatar();
    }
  }

  Widget _buildFallbackAvatar() {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xff00D09E).withValues(alpha: 0.2),
      child: Text(
        userName.isNotEmpty ? userName[0].toUpperCase() : '?',
        style: GoogleFonts.poppins(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.bold,
          color: const Color(0xff00D09E),
        ),
      ),
    );
  }
}
