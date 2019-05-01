import 'package:flutter/material.dart';
import '../models/WifiArea.dart';
import '../models/ScanResults.dart' show ScanResult;

import '../services/matrix2.dart';
import 'dart:math';

class MapDrawer extends CustomPainter {
  final WifiArea wifiArea;
  final List<ScanResult> scanList;
  double _offsetX;
  double _offsetY;
  double _unitSize;
  
  Paint accessPointPaint = Paint()..strokeWidth = 2.0..color = Colors.red..strokeCap = StrokeCap.round;
  Paint wallPaint = Paint()..strokeWidth = 1.0..color = Color(0xff909090)..strokeCap = StrokeCap.butt;
  Paint doorPaint = Paint()..strokeWidth = 3.0..color = Colors.blue..strokeCap = StrokeCap.butt;
  
  Paint selfPaint = Paint()..strokeWidth = 3.0..color = Colors.pink..strokeCap = StrokeCap.round;

  MapDrawer({this.wifiArea, this.scanList});

  double _calculateUnit(Size size) {
    _offsetY = 25.0;
    double unitSize = (size.height - _offsetY * 2) / wifiArea.corners.y;
    _offsetX = (size.width - (wifiArea.corners.x * unitSize))/2;
    return unitSize;
  }

  void _drawAccessPoints(Canvas canvas) => wifiArea.accessPoints.forEach((AccessPoint ap) => canvas.drawCircle(_scaleVector(ap.coordinates), _unitSize/5, accessPointPaint));
  
  void _drawWalls(Canvas canvas) => wifiArea.walls.forEach((List<Vector2> points) => canvas.drawLine(_scaleVector(points[0]), _scaleVector(points[1]), wallPaint));
  
  void _drawDoors(Canvas canvas) => wifiArea.doors.forEach((List<Vector2> points) => canvas.drawLine(_scaleVector(points[0]), _scaleVector(points[1]), doorPaint));

  Offset _scaleVector(Vector2 vector) => Offset((vector.x * _unitSize) + _offsetX, (vector.y * _unitSize) + _offsetY);

  double _dbToDistance(int db) => -((db + 15)/5);

  void _locate(Canvas canvas) {
    List<double> distances = [];
    
    wifiArea.accessPoints.forEach((AccessPoint point){
      var sRes = scanList.where((ScanResult r) => r.BSSID == point.BSSID).toList();
      if(sRes.length > 0) {
        distances.add(_dbToDistance(sRes[0].level));
      }
    });
    
    if(distances.length > (wifiArea.accessPoints.length - 1)) {
      Matrix2 m1 = Matrix2(
        Vector2(
          x: (pow(distances[0], 2) - pow(distances[1], 2)) - (pow(wifiArea.accessPoints[0].coordinates.x, 2) - pow(wifiArea.accessPoints[1].coordinates.x, 2)) - (pow(wifiArea.accessPoints[0].coordinates.y, 2) - pow(wifiArea.accessPoints[1].coordinates.y, 2)),
          y: 2 * (wifiArea.accessPoints[1].coordinates.y - wifiArea.accessPoints[0].coordinates.y)
        ),
        Vector2(
          x: (pow(distances[0], 2) - pow(distances[2], 2)) - (pow(wifiArea.accessPoints[0].coordinates.x, 2) - pow(wifiArea.accessPoints[2].coordinates.x, 2)) - (pow(wifiArea.accessPoints[0].coordinates.y, 2) - pow(wifiArea.accessPoints[2].coordinates.y, 2)),
          y: 2 * (wifiArea.accessPoints[2].coordinates.y - wifiArea.accessPoints[0].coordinates.y)
        )
      );
      
      Matrix2 m2 = Matrix2(
        Vector2(
          x: 2 * (wifiArea.accessPoints[1].coordinates.x - wifiArea.accessPoints[0].coordinates.x),
          y: 2 * (wifiArea.accessPoints[1].coordinates.y - wifiArea.accessPoints[0].coordinates.y)
        ),
        Vector2(
          x: 2 * (wifiArea.accessPoints[2].coordinates.x - wifiArea.accessPoints[0].coordinates.x),
          y: 2 * (wifiArea.accessPoints[2].coordinates.y - wifiArea.accessPoints[0].coordinates.y)
        )
      );
      
      var x = m1.divide(m2).determinant;
      
      Matrix2 m3 = Matrix2(
        Vector2(
          x: m2.coords[0][0],
          y: m2.coords[1][0]
        ),
        Vector2(
          x: m1.coords[0][0],
          y: m1.coords[1][0]
        )
      );
      
      var y = m3.divide(m2).determinant;
      
      var pos = Vector2(x: x, y: y);
      canvas.drawCircle(_scaleVector(pos), _unitSize/3, selfPaint);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(wifiArea.corners != null) {
      _unitSize = _calculateUnit(size);
      
      _drawAccessPoints(canvas);
      _drawWalls(canvas);
      _drawDoors(canvas);
      _locate(canvas);
    }
  }

  @override
  bool shouldRepaint(MapDrawer oldDelegate) => true;
}