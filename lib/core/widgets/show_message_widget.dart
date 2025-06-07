import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ShowMessage extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String? description;
  final ToastificationType type;
  final Alignment alignment;
  final Duration duration;

  const ShowMessage({
    super.key,
    required this.context,
    required this.title,
    this.description,
    required this.type,
    required this.alignment,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    toastification.show(
      context: context,
      title: Text(title),
      description: description != null ? Text(description!) : null,
      type: type,
      alignment: alignment,
      autoCloseDuration: duration,
    );
    return const SizedBox.shrink();
  }
}
