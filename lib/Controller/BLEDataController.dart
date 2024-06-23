// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:typed_data';

import 'package:circular_buffer/circular_buffer.dart';
import 'package:esp32_step_counter_app/Model/DaraHistory.dart';
import 'package:esp32_step_counter_app/Model/MotionState.dart';
import 'package:esp32_step_counter_app/Model/SensorSettings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleDataController extends ChangeNotifier {
  final String _DATA_UUID = "2f766cb0-804b-4779-ba00-80a3f08cc70e";
  final String _SENSOR_UUID = "130db0c9-e717-45ba-8a99-21d03144f056";
  final String _ACCELEROMETER_UUID = "7c15c5fb-f9a8-41d2-885f-07db1827370f";
  final String _STEP_UUID = "3595f562-1fa2-45d1-9f77-81d9e70aebca";
  final String _FREQUENCY_UUID = "c8754d82-859f-4724-b6e5-a2e7cd7f7479";
  final String _DISTANCE_UUID = "6ae11cb8-7db8-44bd-aa76-2e5b1df76531";
  BleDataController();
  BluetoothDevice? _device;

  bool _isReady = false;
  bool get isReady => _isReady;

  init(BluetoothDevice device) {
    _device = device;
  }

  CircularBuffer<double> accelerometerStreamData = CircularBuffer<double>(500);
  int _step = 0;
  double _freq = 0;
  double _distance = 0;

  SensorSettings sensorSettings = SensorSettings();

  int get step => _step;
  double get frequency => _freq;
  double get distance => _distance;
  MotionState get motionState => MotionState.standing;
  DataHistory dataHistory = DataHistory();

  /// Inizializia tutti i callback sulle caratteristiche
  Future<void> setup() async {
    if (_device == null) {
      throw "Device null on setup";
    }

    var services = await _device!.discoverServices();
    _setupSensorServices(services);
    _setupDataServices(services);
    _isReady = true;
    notifyListeners();
  }

  /// Inizializza i callback sulle caratteristiche dei sensori come l'accelerometro
  void _setupSensorServices(List<BluetoothService> services) {
    var sensorService = services.singleWhere((element) => element.serviceUuid.toString() == _SENSOR_UUID);
    var subAcc = _filterCaratteristicByUUID(sensorService, _ACCELEROMETER_UUID).lastValueStream.listen((event) {
      double? value = _getDoubleFromBLE(event);
      if (value == null) return;
      accelerometerStreamData.add(value);
      dataHistory.pushValue(value, step, frequency, distance);
      notifyListeners();
    });
    _filterCaratteristicByUUID(sensorService, _ACCELEROMETER_UUID).setNotifyValue(true);

    _device?.cancelWhenDisconnected(subAcc);
  }

  /// Inizializza i callback sulle caratteristiche dei dati come step e frequenza
  void _setupDataServices(List<BluetoothService> services) {
    var sensorService = services.singleWhere((element) => element.serviceUuid.toString() == _DATA_UUID);
    var subStep = _filterCaratteristicByUUID(sensorService, _STEP_UUID).lastValueStream.listen((event) {
      int? value = _getIntFromBLE(event);
      if (value == null) return;
      _step = value;
      dataHistory.addStep();
      notifyListeners();
    });

    var subFreq = _filterCaratteristicByUUID(sensorService, _FREQUENCY_UUID).lastValueStream.listen((event) {
      double? value = _getDoubleFromBLE(event);
      if (value == null) return;
      _freq = value;
      notifyListeners();
    });

    var subDist = _filterCaratteristicByUUID(sensorService, _DISTANCE_UUID).lastValueStream.listen((event) {
      double? value = _getDoubleFromBLE(event);
      if (value == null) return;
      _distance = value;
      notifyListeners();
    });

    _filterCaratteristicByUUID(sensorService, _FREQUENCY_UUID).setNotifyValue(true);
    _filterCaratteristicByUUID(sensorService, _STEP_UUID).setNotifyValue(true);
    _filterCaratteristicByUUID(sensorService, _DISTANCE_UUID).setNotifyValue(true);
    _device?.cancelWhenDisconnected(subStep);
    _device?.cancelWhenDisconnected(subFreq);
    _device?.cancelWhenDisconnected(subDist);
  }

  /// Trova dentro un servizio la caratteristicha con l'[uuid] fornito
  BluetoothCharacteristic _filterCaratteristicByUUID(BluetoothService service, String uuid) {
    return service.characteristics.firstWhere((element) => element.uuid == Guid(uuid));
  }

  /// Da un array di interi a 8 bit che arrivano dal BLE costruisce un valore double
  double? _getDoubleFromBLE(List<int> eventList) {
    final bytes = Uint8List.fromList(eventList);

    if (bytes.length != 4) return null;

    final byteData = ByteData.sublistView(bytes);
    return byteData.getFloat32(0, Endian.little);
  }

  /// Da un array di interi a 8 bit che arrivano dal BLE costruisce un valore int
  int? _getIntFromBLE(List<int> eventList) {
    final bytes = Uint8List.fromList(eventList);
    if (bytes.length != 4) return null;

    final byteData = ByteData.sublistView(bytes);
    return byteData.getInt16(0, Endian.little);
  }
}
