import 'package:flutter/material.dart';
import '../models/ScanResults.dart';

class ScanList extends StatelessWidget {

  final ScanResults scanResults;

  ScanList({
    this.scanResults
  });

  Widget _singleListItem(ScanResult item) {
    return Container (
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xfff0f0f0), width: 1.0)),
      ),
      child: ListTile (
        title: Text(item.BSSID, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(item.level.toString() + " dBm"),
        trailing: ImageIcon(AssetImage("images/signal${item.signalLevel}.png")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: scanResults.results.length,
      itemBuilder: (BuildContext context, int index) => _singleListItem(scanResults.results[index]),
    );
  }
}