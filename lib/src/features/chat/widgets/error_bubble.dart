import 'package:flutter/material.dart';

class ErrorBubble extends StatelessWidget {
  final String text;
  const ErrorBubble({required this.text});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.center,
    child: Text(text, style: const TextStyle(color: Colors.red)),
  );
}
