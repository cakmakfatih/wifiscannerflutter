import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'widgets/scan_list.dart';
import 'widgets/wifi_graph.dart';
import 'widgets/indoor_mapper.dart';
import 'models/ScanResults.dart';
import 'models/WifiArea.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const EventChannel _wifiChannel = const EventChannel("com.imbakod.wifiscanner/wifichannel");
  int _currentIndex;
  Stream _wStream;
  WifiArea _wifiArea;

  @override
  void initState() {
    super.initState();
    _wStream = _wifiChannel.receiveBroadcastStream();
    _currentIndex = 0;
    _wifiArea = WifiArea();

    _loadMap();
  }

  void _loadMap() async {
    WifiArea wifiArea = WifiArea.fromJson(json.decode(await rootBundle.loadString('resources/map.json')));

    setState(() {
      _wifiArea = wifiArea;
    });
  }

  StreamBuilder _viewController() {
    return StreamBuilder(
      stream: _wStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData) {
          ScanResults scanResults = ScanResults.fromJson(snapshot.data);
          scanResults.results.sort((a, b) => b.level.compareTo(a.level));

          switch(_currentIndex) {
            case 0:
              return ScanList(scanResults: scanResults);
              break;
            case 1:
              return WifiGraph(scanResults: scanResults);
              break;
            case 2:
              return IndoorMapper(wifiArea: _wifiArea, scanResults: scanResults);
              break;
            default:
              return loader();
              break;
          }
        } else {
          return loader();
        }
      }
    );
  }

  Widget loader() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        elevation: 0.5,
        title: Text(
          "WifiScanner",
          style: TextStyle(
            color: Colors.teal
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.green
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            title: Text('List'),
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            title: Text('Graph'),
            icon: Icon(Icons.graphic_eq),
          ),
          BottomNavigationBarItem(
            title: Text('Map'),
            icon: Icon(Icons.location_on),
          )
        ],
      ),
      body: _viewController()
    );
  }
}