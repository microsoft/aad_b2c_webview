import 'package:flutter/material.dart';

class DefaultError extends StatelessWidget {
  final String? message;
  const DefaultError({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(message ?? 'An error occurred.'),
    );
  }
}
