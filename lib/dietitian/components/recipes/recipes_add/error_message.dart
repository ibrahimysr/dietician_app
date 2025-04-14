import 'package:flutter/material.dart';

class ErrorMessageDisplay extends StatelessWidget {
  final String? errorMessage;

  const ErrorMessageDisplay({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    if (errorMessage == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200)),
        child: Text(
          errorMessage!,
          style: TextStyle(color: Colors.red.shade800, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}