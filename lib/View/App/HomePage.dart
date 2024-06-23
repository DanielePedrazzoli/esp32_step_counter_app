import 'package:esp32_step_counter_app/Controller/BLEDataController.dart';
import 'package:esp32_step_counter_app/View/Components/valueCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  final BleDataController controller;
  const HomePage({super.key, required this.controller});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ValueCard(
                  icon: MdiIcons.run,
                  title: "Movimento rilevato",
                  value: widget.controller.motionState.name,
                  iconColor: Colors.red,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ValueCard(
                  icon: MdiIcons.bluetooth,
                  title: "Stato connessione",
                  value: FlutterBluePlus.connectedDevices.isNotEmpty ? "Connesso" : "Non conesso",
                  iconColor: Colors.cyan,
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: ValueCard(
                  icon: MdiIcons.footPrint,
                  title: "Passi rilevati",
                  value: widget.controller.step.toString(),
                  iconColor: Colors.green,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: ValueCard(
                  icon: MdiIcons.timer,
                  title: "Frequenza passi",
                  value: "${widget.controller.frequency.toStringAsFixed(2)} pas",
                  iconColor: Colors.lightBlue,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
