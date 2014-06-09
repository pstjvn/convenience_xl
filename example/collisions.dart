import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;
import 'dart:math' show sin, cos;

void main() {
  var stage = new Stage(querySelector('canvas'));
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  var rm = new ResourceManager()
      ..addBitmapData('spaceship', 'spaceship.png')
      ..addBitmapData('asteroid', 'icon.png')
      ..load().then((_) {

        var asteroid = new IrregularBitmap()
            ..bitmapData = _.getBitmapData('asteroid')
            ..setPolygonPoints(asteroidPoints);
        var ship = new IrregularBitmap()
            ..bitmapData = _.getBitmapData('spaceship')
            ..setPolygonPoints(spaceshipPoints);

        var demo = new Demo()
            ..ship = ship
            ..asteroid = asteroid
            ..juggler = juggler
            ..rd = new RotationDescriptor(speed: 2);

        stage
            ..addChild(ship)
            ..addChild(asteroid);

        center(ship);
        centerPivot(asteroid);

        // Adds collision detection (and rotation for fx)
        juggler.add(demo);

        // Adds movement of the asteroid
        juggler.add(new Tween(asteroid, 3, TransitionFunction.linear)
            ..animate.x.to(stage.contentRectangle.width - asteroid.width + asteroid.pivotX)
            ..animate.y.to(stage.contentRectangle.height - asteroid.height + asteroid.pivotY)
            ..delay = 3);

        // Allow the user to rotate the spaceship (different collisions!)
        var handler = new ArrowKeysHandler(stage);
        handler.onKeyPressed.listen((num rad) {
          ship.rotation = rad;
        });

        stage.focus = stage;
      }
  );
}

class Demo implements Animatable {
  IrregularBitmap ship;
  IrregularBitmap asteroid;
  RotationDescriptor rd;
  Juggler juggler;

  Demo();
  bool advanceTime(num t) {
    rd.delta = t;
    asteroid.rotation += rd.radians;
    ship.x = ship.x + 1 * cos(ship.rotation);
    ship.y = ship.y + 1 * sin(ship.rotation);
    if (ship.collides(asteroid)) {
      juggler.removeTweens(asteroid);
      return false;
    }
    return true;
  }
}

List<Point<int>> spaceshipPoints = [
  new Point(121, 64),
  new Point(74, 87),
  new Point(80, 103),
  new Point(51, 106),
  new Point(45, 77),
  new Point(5, 65),
  new Point(44, 50),
  new Point(51, 21),
  new Point(81, 23),
  new Point(72, 39)
];

List<Point<int>> asteroidPoints = [
  new Point(32, 0),
  new Point(48, 21),
  new Point(41, 43),
  new Point(31, 48),
  new Point(18, 48),
  new Point(5, 43),
  new Point(1, 37),
  new Point(4, 10),
  new Point(10, 4)
];

void centerPivot(Bitmap bm) {
  bm
      ..pivotX = bm.width / 2
      ..pivotY = bm.height / 2
      ..x = bm.x + bm.pivotX
      ..y = bm.y + bm.pivotY;
}

void center(Bitmap bm) {
  bm
      ..pivotX = bm.width / 2
      ..pivotY = bm.height / 2
      ..x = bm.stage.contentRectangle.width / 2 - bm.width / 2 + bm.pivotX
      ..y = bm.stage.contentRectangle.height / 2 - bm.height / 3 + bm.pivotY;
}