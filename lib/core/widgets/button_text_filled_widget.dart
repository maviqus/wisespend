import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonTextFilledWidget extends StatefulWidget {
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPasswordField;
  final Color fillColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final double height;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;

  const ButtonTextFilledWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPasswordField = false,
    this.fillColor = const Color(0xff1F222A),
    this.borderRadius = 12,
    this.textStyle,
    this.height = 60,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
  });

  @override
  State<ButtonTextFilledWidget> createState() => _ButtonTextFilledWidgetState();
}

class _ButtonTextFilledWidgetState extends State<ButtonTextFilledWidget> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height.h,
      decoration: BoxDecoration(
        color: widget.fillColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscureText,
          obscuringCharacter: '•',
          cursorColor: const Color(0xffFFFFFF),
          style:
              widget.textStyle ??
              TextStyle(
                color: const Color(0xff9E9E9E),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.symmetric(vertical: 20.h),
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle:
                widget.textStyle ??
                TextStyle(
                  color: const Color(0xff9E9E9E),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: widget.prefixIcon,
                  )
                : null,
            suffixIcon: widget.isPasswordField
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: const Color(0xff9E9E9E),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
