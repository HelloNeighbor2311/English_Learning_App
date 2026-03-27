import 'package:flutter/material.dart';

class StatusMessageBanner extends StatelessWidget {
  final String message;
  final bool isError;

  const StatusMessageBanner({
    super.key,
    required this.message,
    this.isError = true,
  });

  @override
  Widget build(BuildContext context) {
    final background = isError ? const Color(0xFFFFEEF0) : const Color(0xFFEAF8EF);
    final border = isError ? const Color(0xFFFFC9CF) : const Color(0xFFB8E5C6);
    final iconColor = isError ? const Color(0xFFC62839) : const Color(0xFF1B7F3A);
    final textColor = isError ? const Color(0xFF8F1F2D) : const Color(0xFF1E5F36);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
