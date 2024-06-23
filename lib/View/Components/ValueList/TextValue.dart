import 'package:flutter/material.dart';

class TextValue extends StatelessWidget {
  final String title;
  final String value;
  const TextValue({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(value),
      dense: true,
    );
  }
}
