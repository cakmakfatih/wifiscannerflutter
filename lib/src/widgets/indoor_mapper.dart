import 'package:flutter/material.dart';
import 'map_drawer.dart';
import '../models/WifiArea.dart';
import '../models/ScanResults.dart';

class IndoorMapper extends StatelessWidget {
  final WifiArea wifiArea;
  final ScanResults scanResults;

  IndoorMapper({
    this.wifiArea,
    this.scanResults
  });

  @override
  Widget build(BuildContext context) {
    List<ScanResult> filteredList = scanResults.results.where((ScanResult r) => wifiArea.accessPoints.indexWhere((AccessPoint p) => p.BSSID == r.BSSID) != -1).toList();
    
    return Container(
      child: CustomPaint(painter: MapDrawer(wifiArea: wifiArea, scanList: filteredList), size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height))
    );
  }
}