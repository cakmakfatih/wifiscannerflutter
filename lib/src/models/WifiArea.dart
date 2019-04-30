class WifiArea {
  Vector2 corners;
  List<AccessPoint> accessPoints;
  List<List<Vector2>> walls;
  List<List<Vector2>> doors;

  WifiArea({
    this.corners,
    this.accessPoints,
    this.walls,
    this.doors
  });

  factory WifiArea.fromJson(dynamic json) {
    return WifiArea(
      corners: Vector2.fromJson(json["corners"] as List),
      accessPoints: (json["access_points"] as List<dynamic>).map<AccessPoint>((dynamic i) => AccessPoint.fromJson(i)).toList(),
      walls: (json["walls"] as List<dynamic>).map<List<Vector2>>((dynamic i) => [
        Vector2(x: i[0][0], y: i[0][1]),
        Vector2(x: i[1][0], y: i[1][1])
      ]).toList(),
      doors: (json["doors"] as List<dynamic>).map<List<Vector2>>((dynamic i) => [
        Vector2(x: i[0][0], y: i[0][1]),
        Vector2(x: i[1][0], y: i[1][1])
      ]).toList(),
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