import 'package:esp32_step_counter_app/Controller/BLEConnectionController.dart';
import 'package:esp32_step_counter_app/View/App/AppPage.dart';
import 'package:esp32_step_counter_app/View/BLE/BluethootAvaiableDevice.dart';
import 'package:flutter/material.dart';

class BLEConnection extends StatefulWidget {
  final BLEConnectionController controller;
  const BLEConnection({super.key, required this.controller});

  @override
  State<BLEConnection> createState() => _BLEConnectionState();
}

class _BLEConnectionState extends State<BLEConnection> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> iconSizeAnimation;
  bool allreadyPushed = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    var curve = CurvedAnimation(curve: Curves.easeInOut, parent: controller);
    iconSizeAnimation = Tween<double>(begin: 90, end: 100).animate(curve);
    iconSizeAnimation.addListener(() {
      if (mounted) setState(() {});
    });
    controller.repeat(reverse: true);

    widget.controller.startScan();
    controller.addListener(checkConnection);
  }

  void checkConnection() async {
    if (widget.controller.isConnected) {
      if (allreadyPushed) return;
      widget.controller.removeListener(checkConnection);

      allreadyPushed = true;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AppPage(device: widget.controller.device)),
      );

      widget.controller.disconnnect();
      allreadyPushed = false;
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(checkConnection);

    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        if (widget.controller.scanResult.isNotEmpty) {
          return BluethootAvaiableDevice(controller: widget.controller);
        }
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: Icon(
                    Icons.bluetooth_searching,
                    size: iconSizeAnimation.value.toDouble(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 60),
                Text("Ricerca dispositivo in corso", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
