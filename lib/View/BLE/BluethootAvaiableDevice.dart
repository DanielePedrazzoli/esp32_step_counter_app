import 'package:esp32_step_counter_app/Controller/BLEConnectionController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluethootAvaiableDevice extends StatelessWidget {
  final BLEConnectionController controller;
  const BluethootAvaiableDevice({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          ScanResult result = controller.scanResult[index];
          if (result.device.advName.isEmpty) return const SizedBox();
          return Card(
            child: ListTile(
              title: Text(result.device.advName),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connessione a ${result.device.advName} in corso")));
                controller.connectTo(result);
              },
            ),
          );
        },
        itemCount: controller.scanResult.length,
      ),
    );
  }
}
