class WifiArea {
  Vector2 corners;
  List<AccessPoint> accessPoints;

  WifiArea({
    this.corners,
    this.accessPoints
  });

  factory WifiArea.fromJson(dynamic json) {
    return WifiArea(
      corners: Vector2.fromJson(json["corners"] as List),
      accessPoints: (json["access_points"] as List<dynamic>).map<AccessPoint>((dynamic i) => AccessPoint.fromJson(i)).toList(),
    );
  }
}

class Vector2 {
  double x;
  double y;

  Vector2({
    this.x: 0,
    this.y: 0
  });

  factory Vector2.fromJson(dynamic coords) {
    return Vector2(
      x: (coords as List)[0],
      y: (coords as List)[1]
    );
  }
}

class AccessPoint {
  String SSID;
  Vector2 coordinates;

  AccessPoint({
    this.SSID, 
    this.coordinates
  });

  factory AccessPoint.fromJson(dynamic json) {
    return AccessPoint(
      SSID: json["SSID"],
      coordinates: Vector2.fromJson(json["coordinates"]),
    );
  }
}