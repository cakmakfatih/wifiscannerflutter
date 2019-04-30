import 'package:flutter/material.dart';
import '../models/WifiArea.dart';

import 'dart:math';

class MapDrawer extends CustomPainter {
  WifiArea wifiArea;
  double _unitSize;
  
  Paint accessPointPaint = Paint()..strokeWidth = 2.0..color = Colors.red..strokeCap = StrokeCap.round;
  Paint wallPaint = Paint()..strokeWidth = 1.0..color = Color(0xff909090)..strokeCap = StrokeCap.butt;
  Paint doorPaint = Paint()..strokeWidth = 3.0..color = Colors.blue..strokeCap = StrokeCap.butt;

  MapDrawer({this.wifiArea});

  double _calculateUnit(Size size) {
    return size.height / wifiArea.corners.y;
  }

  void _drawAccessPoints(Canvas canvas) {
    wifiArea.accessPoints.forEach((AccessPoint ap) => canvas.drawCircle(_scaleVector(ap.coordinates), _unitSize/5, accessPointPaint));
  }
  
  void _drawWalls(Canvas canvas) {
    wifiArea.walls.forEach((List<Vector2> points) => canvas.drawLine(_scaleVector(points[0]), _scaleVector(points[1]), wallPaint));
  }
  
  void _drawDoors(Canvas canvas) {
    wifiArea.doors.forEach((List<Vector2> points) => canvas.drawLine(_scaleVector(points[0]), _scaleVector(points[1]), doorPaint));
  }
  
  double _dbToDistance(double db) {
    return 5;
  }
  
  void _locate(Vector2 v1, Vector2 v2, Vector2 v3) {
    var d1 = _dbToDistance(2);
    var d2 = _dbToDistance(2);
    var d3 = _dbToDistance(2);
    
    var xN11 = (pow(d1, 2) - pow(d2, 2)) - (pow(v1.x, 2) - pow(v2.x, 2)) - (pow(v1.y, 2) - pow(v2.y, 2));
    var xN21 = (pow(d1, 2) - pow(d3, 2)) - (pow(v1.x, 2) - pow(v3.x, 2)) - (pow(v1.y, 2) - pow(v3.y, 2));
    
    var xN12 = 2 * (v2.y - v1.y);
    var xN22 = 2 * (v3.y - v1.y);
    
    var d11 = 2 * (v2.x - v1.x);
    var d21 = 2 * (v3.x - v1.x);
    var d12 = 2 * (v2.y - v1.y);
    var d22 = 2 * (v3.y - v1.y);
    
    var det1 = (xN11 * xN22) - (xN12 * xN21);
    var det2 = (d11 * d22) - (d12 * d21);
    
    
  }

  Offset _scaleVector(Vector2 vector) {
    return Offset(vector.x * _unitSize, vector.y * _unitSize);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(wifiArea.corners != null) {
      _unitSize = _calculateUnit(size);
      _drawAccessPoints(canvas);
      _drawWalls(canvas);
      _drawDoors(canvas);
    }
  }

  @override
  bool shouldRepaint(MapDrawer oldDelegate) => true;
}