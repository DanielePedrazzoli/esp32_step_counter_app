import 'package:esp32_step_counter_app/Controller/BLEDataController.dart';
import 'package:flutter/material.dart';

class Calibrationpage extends StatefulWidget {
  final BleDataController controller;
  const Calibrationpage({super.key, required this.controller});

  @override
  State<Calibrationpage> createState() => _CalibrationpageState();
}

class _CalibrationpageState extends State<Calibrationpage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
