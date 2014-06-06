part of convenience_xl;



/**
 * Abstract class for collision detection.
 *
 * Mix in this class to enable collision detection for the objects
 */
abstract class CollidingObject {
  /// Describes the dependency on instance property.
  Polygon polygonalView;
  /// Describes a mixed class dependency. Basically describes Bitmap.
  Matrix get transformationMatrix;

  /// Returns the transformed polygon.
  Polygon get transformedPolygon {
    var points = [];
    polygonalView.points.forEach((p) {
      points.add(transformationMatrix.transformPoint(p));
    });
    return new Polygon(points);
  }

  /// Checks is the two objects collide using polygonal contains algorythm.
  bool collides(CollidingObject target) {

    // at this point we need to transform each of the two polygons and
    // test against the transformation

    var p1 = this.transformedPolygon;
    var p2 = target.transformedPolygon;

    for (var i = 0; i < p1.points.length; i++) {
      if (collidesImplementation(p1.points[i], p2)) {
        return true;
      }
    }
    for (var i = 0; i < p2.points.length; i++) {
      if (collidesImplementation(p2.points[i], p1)) {
        return true;
      }
    }
    return false;
  }

  /// Internal implementation of the checking. Basically it calls on the
  /// implementation provided by StageXL
  bool collidesImplementation(Point p, Polygon target) {
    return target.contains(p.x, p.y);
  }
}



/**
 *  Stupid hack to overcome bug in Mixin implementation
 *  (see)[https://code.google.com/p/dart/issues/detail?id=15101]
 */
class _Intermediate extends Bitmap {
  _Intermediate();
}



/**
 * Provides a mixed in class with the capability to check for collision with
 * another object that mixes in the [CollisingObject] as well.
 */
class IrregularBitmap extends _Intermediate with CollidingObject {

  /// The polygon that describes the bitmap shape
  Polygon polygonalView;

  IrregularBitmap(): super();

  /// Actual implementation for the polygon creation. Could be overriden if special polygon (mutable) is needed.
  createPolygonImplementation(List<Point<num>> points) {
    polygonalView = new Polygon(points);
  }

  /**
   * Sets the points to construct the polygon from. The point values will be
   * copied over.
   *
   * In this implementation this is not really nessesary because the points
   * are not altered. Instead the transformation matrix of the [Bitmap] class
   * is used to determine the actual position of the [Point] on the screen.
   *
   * The copying is done in case those would be manipulated by the game logic (
   * for example deformation/mutation of the objects, for example a subclass of
   * [Polygon]).
   *
   * Note that this should be done only once (usually).
   */
  void setPolygonPoints(List<Point<int>> list) {
    var ps = [];
    list.forEach((p) {
      ps.add(new Point.from(p));
    });
    createPolygonImplementation(ps);
  }
}
