import 'package:esp32_step_counter_app/Controller/BLEConnectionController.dart';
import 'package:esp32_step_counter_app/View/BLE/BluetoothConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

late BLEConnectionController bleController;

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FlutterBluePlus.setLogLevel(LogLevel.error, color: false);
    bleController = BLEConnectionController().init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color.fromARGB(255, 239, 239, 239),
        cardTheme: CardTheme(
          color: const Color.fromRGBO(251, 251, 251, 1),
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 239, 239, 239),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: const Color.fromRGBO(251, 251, 251, 1),
          elevation: 2,
          selectedItemColor: Colors.blue[700],
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          enableFeedback: false,
        ),
      ),
      home: BLEConnection(controller: bleController),
    );
  }
}
