import 'package:flutter/material.dart';

Future<int?> showExportDialog(BuildContext context) async {
  return await showDialog<int>(
    context: context,
    builder: (context) => Dialog(
      child: Padding(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Modalità di esportazione",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Card.outlined(
              child: ListTile(
                title: const Text("Dall'inizio"),
                subtitle: const Text("Totale di x campioni"),
                onTap: () => Navigator.pop(context, 1),
              ),
            ),
            ListTile(
              title: const Text("Dall'ultima esportazione"),
              subtitle: const Text("Totale di y campioni"),
              onTap: () => Navigator.pop(context, 2),
            ),
          ],
        ),
      ),
    ),
  );
}
