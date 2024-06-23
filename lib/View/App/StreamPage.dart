import 'dart:ffi';

import 'package:esp32_step_counter_app/Controller/BLEDataController.dart';
import 'package:esp32_step_counter_app/View/Components/ValueList/TextValue.dart';
import 'package:esp32_step_counter_app/View/Components/ValueList/ValueList.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class StreamPage extends StatefulWidget {
  final BleDataController controller;

  const StreamPage({super.key, required this.controller});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) => SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Streaming valori", style: Theme.of(context).textTheme.titleMedium),
                Card.filled(
                  child: SfCartesianChart(
                    palette: const [
                      Colors.blue,
                      Colors.green,
                      Colors.red,
                    ],
                    legend: const Legend(isVisible: false),
                    enableSideBySideSeriesPlacement: false,
                    primaryYAxis: const NumericAxis(
                      maximum: 3,
                      minimum: 0,
                      plotBands: [
                        PlotBand(
                          start: 1.5,
                          end: 1.2,
                          color: Color.fromARGB(43, 244, 67, 54),
                          borderColor: Color.fromARGB(129, 244, 67, 54),
                        ),
                        PlotBand(
                          start: 0.55,
                          end: 0.40,
                          color: Color.fromARGB(57, 54, 54, 244),
                          borderColor: Color.fromARGB(129, 54, 54, 244),
                        ),
                        PlotBand(
                          start: 0.3,
                          end: 0.2,
                          color: Color.fromARGB(73, 54, 244, 73),
                          borderColor: Color.fromARGB(129, 54, 244, 73),
                        ),
                      ],
                    ),
                    series: [
                      LineSeries(
                        animationDuration: 0,
                        dataSource: widget.controller.accelerometerStreamData.toList(),
                        xValueMapper: (_, x) => x,
                        yValueMapper: (dynamic data, y) => data / (16338),
                      ),
                    ],
                  ),
                ),
                // Card.filled(
                //   child: SfSparkAreaChart(
                //     // axisCrossesAt: 2,
                //     plotBand: SparkChartPlotBand(start: 15, end: 25),
                //     // marker: SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.all),
                //     data: widget.controller.accelerometerStreamData.map((e) => e / 16338).toList(),
                //     // data: <double>[18, 24, 30, 14, 28],
                //   ),
                // ),
                // Card.filled(
                //   child: SfSparkAreaChart(
                //     // axisCrossesAt: 2,
                //     plotBand: SparkChartPlotBand(start: 15, end: 25),
                //     // marker: SparkChartMarker(displayMode: SparkChartMarkerDisplayMode.all),
                //     data: widget.controller.accelerometerStreamData.map((e) => e / 16338).toList(),
                //     // data: <double>[18, 24, 30, 14, 28],
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 20),
            ValueList(
              title: "Valori ottenuti",
              children: [
                TextValue(title: "Step", value: widget.controller.step.toString()),
                TextValue(title: "Frequenza", value: "${widget.controller.frequency.toStringAsFixed(3)} passi al secondo"),
                TextValue(title: "distanza", value: "${widget.controller.distance.toStringAsFixed(2)} metri"),
              ],
            ),
            const SizedBox(height: 20),
            const ValueList(
              title: "Valori calcolati in app",
              children: [
                TextValue(title: "Threshold attuale", value: "0"),
                TextValue(title: "Media", value: "0"),
                TextValue(title: "Varianza", value: "0"),
              ],
            )
          ],
        ),
      ),
    );
  }
}
