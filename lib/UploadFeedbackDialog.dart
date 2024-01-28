import 'package:flutter/material.dart';

class UploadFeedbackDialog extends StatelessWidget {
  final String message;
  final VoidCallback? onTimerEnd;
  final TextStyle messageTextStyle;

  const UploadFeedbackDialog({
    super.key,
    required this.message,
    this.onTimerEnd,
    required this.messageTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color.fromARGB(255, 99, 136, 255),
          ),
          const SizedBox(height: 10.0),
          Text(
            message,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}