import 'package:flutter/material.dart';
import '../models/ScanResults.dart';

import 'package:charts_flutter/flutter.dart' as charts;

class WifiGraph extends StatelessWidget {

  final ScanResults scanResults;
  WifiGraph({
    this.scanResults
  });

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ScanResult, String>> sList = [
      new charts.Series<ScanResult, String>(
        id: 'Scan Results',
        domainFn: (ScanResult scanResult, _) => scanResult.SSID,
        measureFn: (ScanResult scanResult, _) => scanResult.level,
        data: scanResults.results.length >= 10 ? scanResults.results.sublist(0, 10) : scanResults.results,
        labelAccessorFn: (ScanResult scanResult, _) => (scanResult.level.toString() + " dBM: " + (scanResult.SSID.length > 12 ? scanResult.SSID.substring(0, 10) + ".." : scanResult.SSID))
      )
    ];

    return new charts.BarChart(
      sList,
      animate: true,
      vertical: false,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec(),),
    );
  }
}