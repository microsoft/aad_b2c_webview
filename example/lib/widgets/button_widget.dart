import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final IconData icon;
  final double elevation;
  final Color backgroundColor;

  const ButtonWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.icon,
    this.elevation = 2.0,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onTap,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(elevation),
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        trailing: const SizedBox(),
      ),
    );
  }
}
