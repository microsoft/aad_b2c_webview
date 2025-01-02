import 'package:flutter/material.dart';

class DefaultLoading extends StatelessWidget {
  const DefaultLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
