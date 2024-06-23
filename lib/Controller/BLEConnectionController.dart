import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEConnectionController extends ChangeNotifier {
  BLEConnectionController();
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  BluetoothDevice? _device;
  bool _connected = false;

  bool get isConnected => _connected;
  bool get isScanning => _isScanning;
  List<ScanResult> get scanResult => _scanResults;
  BluetoothDevice get device => _device!;

  BLEConnectionController init() {
    FlutterBluePlus.scanResults.listen((results) async {
      _scanResults = results;
      if (_scanResults.length == 1) {
        await connectTo(scanResult.first);
        _connected = true;
      }
      notifyListeners();
    }, onError: (_) => {});

    FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      notifyListeners();
    });

    return this;
  }

  void startScan() async {
    await FlutterBluePlus.startScan(withNames: ["ESP 32 motion sensor"]);
  }

  Future<void> connectTo(ScanResult scanResult) async {
    _device = scanResult.device;
    await _device?.connect();
    _connected = true;
    notifyListeners();
  }

  void disconnnect() {
    _device?.disconnect();
    _connected = false;
    notifyListeners();
  }
}
