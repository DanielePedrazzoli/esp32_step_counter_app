import 'package:flutter/material.dart';

class ValueList extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const ValueList({super.key, required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) Text(title!, style: Theme.of(context).textTheme.titleMedium),
        Card.filled(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...children,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
