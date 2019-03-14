import 'package:flutter/material.dart';
import '../models/WifiArea.dart';

class MapDrawer extends CustomPainter {
  WifiArea wifiArea;
  double _unitSize;

  MapDrawer({this.wifiArea});

  double _calculateUnit(Size size) {
    return size.height / wifiArea.corners.y;
  }

  void _drawAccessPoints(Canvas canvas) {
    Paint paint = new Paint()
          ..strokeWidth = 2.0
          ..color = Colors.red
          ..strokeCap = StrokeCap.round;
    wifiArea.accessPoints.forEach((AccessPoint ap) => canvas.drawCircle(_scaleVector(ap.coordinates), _unitSize/15, paint));
  }

  Offset _scaleVector(Vector2 vector) {
    return Offset(vector.x * _unitSize, vector.y * _unitSize);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(wifiArea.corners != null) {
      _unitSize = _calculateUnit(size);

      _drawAccessPoints(canvas);
    }
  }

  @override
  bool shouldRepaint(MapDrawer oldDelegate) => true;
}