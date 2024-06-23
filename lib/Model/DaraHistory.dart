import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DataHistory {
  final List<double> _accelerometeValues = [];
  final List<int> _steps = [];
  final List<double> _frequency = [];
  final List<int> _stepDetected = [];
  final List<double> _distance = [];

  int _lastExportIndex = 0;

  DataHistory();

  void pushValue(double acc, int stepCounter, double freqValue, double distance) {
    _accelerometeValues.add(acc);
    _steps.add(stepCounter);
    _frequency.add(freqValue);
    _distance.add(distance);
  }

  void addStep() {
    _stepDetected.add(_accelerometeValues.length);
  }

  Future<void> exportFromBegin() async {
    await _export(0);
  }

  Future<void> exportFromLastExport() async {
    var index = await _export(_lastExportIndex);
    _lastExportIndex = index;
  }

  Future<int> _export(int startingIndex) async {
    List<double> accelerometerCopy = _accelerometeValues.sublist(startingIndex);
    List<int> stepsCopy = _steps.sublist(startingIndex);
    List<double> frequencyCopy = _frequency.sublist(startingIndex);
    List<double> distanceCopy = _distance.sublist(startingIndex);
    List<int> stepDetectedCopy = _stepDetected.sublist(startingIndex);

    var stepDectedList = List.generate(accelerometerCopy.length, (int index) {
      if (stepDetectedCopy.contains(index)) {
        return 1;
      }
      return 0;
    });

    String fileContent = "";
    for (int i = 0; i < accelerometerCopy.length; i++) {
      String str = "${accelerometerCopy[i]};${stepsCopy[i]};${frequencyCopy[i]};${stepDectedList[i]};${distanceCopy[i]}";
      fileContent += "$str\n";
    }
    var directory = (await getExternalStorageDirectory())!;
    bool hasExisted = await directory.exists();
    if (!hasExisted) {
      directory.create();
    }

    DateTime now = DateTime.now();
    String filename = now.toString();

    File file = File("${directory.path}/$filename.csv");
    await file.writeAsString(fileContent);

    return accelerometerCopy.length;
  }
}
