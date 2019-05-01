import '../models/WifiArea.dart' show Vector2;

class Matrix2 {
  List<List<double>> coords;
  
  Matrix2(Vector2 v1, Vector2 v2) {
    coords = [
      [v1.x, v1.y],
      [v2.x, v2.y]
    ];
  }
  
  double get determinant => (coords[0][0] * coords[1][1]) - (coords[0][1] * coords[1][0]);
  
  Matrix2 scale(double number) {
    return Matrix2(
      Vector2(
        x: coords[0][0] * number,
        y: coords[0][1] * number
      ),
      Vector2(
        x: coords[1][0] * number,
        y: coords[1][1] * number
      )
    );
  }
  
  Matrix2 inverse() {
    return Matrix2(
      Vector2(
        x: coords[1][1],
        y: -coords[0][1]
      ),
      Vector2(
        x: -coords[1][0],
        y: coords[0][0]
      )
    ).scale(1/determinant);
  }
  
  Matrix2 multiplyWithMatrix(Matrix2 val) {
    var r1 = Vector2(
      x: coords[0][0] * val.coords[0][0] + coords[0][1] * val.coords[1][0],
      y: coords[0][0] * val.coords[0][1] + coords[0][1] * val.coords[1][1]
    );
    
    var r2 = Vector2(
      x: coords[1][0] * val.coords[0][0] + coords[1][1] * val.coords[1][0],
      y: coords[1][0] * val.coords[0][1] + coords[1][1] * val.coords[1][1]
    );
    
    return Matrix2(r1, r2);
  }
  
  Matrix2 divide(Matrix2 val) => multiplyWithMatrix(val.inverse());
}