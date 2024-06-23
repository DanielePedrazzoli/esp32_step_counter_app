import 'package:flutter/material.dart';

class ValueCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  final Color? iconColor;
  final String? subValue;
  const ValueCard({super.key, required this.icon, required this.title, required this.value, this.iconColor, this.subValue});

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Container(
        height: 250,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // if (subValue != null)
            //   Text(
            //     subValue!,
            //     textAlign: TextAlign.center,
            //     style: Theme.of(context).textTheme.labelLarge
            //   ),
          ],
        ),
      ),
    );
  }
}
