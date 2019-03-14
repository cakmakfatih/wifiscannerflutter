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
    return Container(
      color: Colors.white,
      child: CustomPaint(painter: MapDrawer(wifiArea: wifiArea), size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height))
    );
  }
}