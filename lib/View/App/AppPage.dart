import 'package:esp32_step_counter_app/Controller/BLEDataController.dart';
import 'package:esp32_step_counter_app/View/App/CalibrationPage.dart';
import 'package:esp32_step_counter_app/View/App/HomePage.dart';
import 'package:esp32_step_counter_app/View/App/StreamPage.dart';
import 'package:esp32_step_counter_app/View/Dialogs/Dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AppPage extends StatefulWidget {
  final BluetoothDevice device;
  const AppPage({super.key, required this.device});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  late PageController pageController;
  int _selectedPage = 0;

  BleDataController bleDataController = BleDataController();

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    initAsync();
  }

  void initAsync() async {
    bleDataController.init(widget.device);
    await bleDataController.setup();
  }

  List<Widget> _buildActions() {
    switch (_selectedPage) {
      case 1:
        return [
          IconButton(
            onPressed: () async {
              var response = await showExportDialog(context);
              switch (response) {
                case 1:
                  await bleDataController.dataHistory.exportFromBegin();
                  return;

                case 2:
                  await bleDataController.dataHistory.exportFromLastExport();
                  return;

                default:
                  return;
              }
            },
            icon: Icon(MdiIcons.fileExport),
          ),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP 32 setp counter"),
        automaticallyImplyLeading: false,
        actions: _buildActions(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: PageView(
          onPageChanged: (int newIndex) {
            _selectedPage = newIndex;
            setState(() {});
          },
          controller: pageController,
          children: [
            HomePage(controller: bleDataController),
            StreamPage(controller: bleDataController),
            Calibrationpage(controller: bleDataController),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int newIndex) {
          _selectedPage = newIndex;
          pageController.animateToPage(_selectedPage, duration: const Duration(milliseconds: 200), curve: Curves.linear);
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.line_axis),
            label: "Stream",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration),
            label: "Calibrazione",
          ),
        ],
      ),
    );
  }
}
