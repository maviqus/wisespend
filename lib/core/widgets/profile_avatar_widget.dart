import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class ProfileAvatar extends StatefulWidget {
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
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Always get the latest photo URL directly from Firebase Auth
    final currentUser = FirebaseAuth.instance.currentUser;
    final latestPhotoUrl = currentUser?.photoURL;

    // Use the latest URL with preference over the provided URL
    final effectiveUrl = latestPhotoUrl ?? widget.profileUrl;

    // Force clear image cache if needed
    if (widget.forceRefresh) {
      imageCache.clear();
      imageCache.clearLiveImages();
    }

    debugPrint("🖼️ ProfileAvatar using URL: $effectiveUrl");

    if (effectiveUrl != null && effectiveUrl.isNotEmpty) {
      // Create a unique cache key that changes when forceRefresh is true
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final cacheKey = ValueKey(
        '$effectiveUrl-$timestamp-${widget.forceRefresh ? 'force' : 'normal'}',
      );

      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.grey.shade200,
        key: cacheKey,
        child: ClipOval(
          child: Image.network(
            effectiveUrl,
            width: widget.radius * 2,
            height: widget.radius * 2,
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
              if (loadingProgress == null) {
                // Dừng shimmer khi đã load xong
                _shimmerController.stop();
                return AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              }
              // Bắt đầu shimmer khi đang loading
              if (!_shimmerController.isAnimating) {
                _shimmerController.repeat();
              }
              return AnimatedBuilder(
                animation: _shimmerController,
                builder: (context, _) {
                  return ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.grey[200]!,
                          Colors.white.withOpacity(0.5),
                          Colors.grey[200]!,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        transform: GradientRotation(
                          _shimmerController.value * 2 * pi,
                        ),
                      ).createShader(bounds);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.grey.shade400,
                          size: widget.radius * 0.8,
                        ),
                      ),
                    ),
                  );
                },
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
      radius: widget.radius,
      backgroundColor: const Color(0xff00D09E).withValues(alpha: 0.2),
      child: Text(
        widget.userName.isNotEmpty ? widget.userName[0].toUpperCase() : '?',
        style: GoogleFonts.poppins(
          fontSize: widget.radius * 0.8,
          fontWeight: FontWeight.bold,
          color: const Color(0xff00D09E),
        ),
      ),
    );
  }
}
