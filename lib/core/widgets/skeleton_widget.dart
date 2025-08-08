import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkeletonWidget extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  });

  factory SkeletonWidget.circular({
    required double radius,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return SkeletonWidget(
      width: radius * 2,
      height: radius * 2,
      borderRadius: BorderRadius.circular(radius),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  factory SkeletonWidget.rectangular({
    required double width,
    required double height,
    double borderRadius = 8,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return SkeletonWidget(
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(borderRadius),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }

  @override
  State<SkeletonWidget> createState() => _SkeletonWidgetState();
}

class _SkeletonWidgetState extends State<SkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.baseColor ?? Colors.grey.shade300;
    final highlightColor = widget.highlightColor ?? Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_animation.value - 1).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 1).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget for skeleton text
class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonWidget(
      width: width ?? 120.w,
      height: height,
      borderRadius: BorderRadius.circular(4.r),
      baseColor: baseColor,
      highlightColor: highlightColor,
    );
  }
}

// Widget for skeleton card
class SkeletonCard extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonCard({
    super.key,
    required this.width,
    required this.height,
    this.padding,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? EdgeInsets.all(8.w),
      child: SkeletonWidget(
        width: width,
        height: height - 16.w, // Trừ padding
        borderRadius: BorderRadius.circular(8.r),
        baseColor: baseColor,
        highlightColor: highlightColor,
      ),
    );
  }
}
