import 'package:flutter/material.dart';
import 'src/homepage.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WifiScanner',
      theme: ThemeData(
        brightness: Brightness.dark,
        canvasColor: Color(0xff202124)
      ),
      home: HomePage(),
    );
  }
}