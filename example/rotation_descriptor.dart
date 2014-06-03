import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'));
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  var resourceManager = new ResourceManager()
      ..addBitmapData('image', 'icon.png')
      ..load().then((ResourceManager rm) {

        var asteroid = new RotatingBitmap(rm.getBitmapData('image'),
            new RotationDescriptor(speed: 2.0));

        asteroid
            ..x = stage.contentRectangle.width / 2 - asteroid.width / 2
            ..y = stage.contentRectangle.height / 2 - asteroid.height / 2
            ..pivotX = asteroid.width / 2
            ..pivotY = asteroid.height / 2
            ..x = asteroid.x + asteroid.pivotX
            ..y = asteroid.y + asteroid.pivotY;

        stage.addChild(asteroid);
        renderLoop.addStage(stage);
        juggler.add(asteroid);
      });
}

class RotatingBitmap extends Bitmap implements Animatable {

  RotationDescriptor rotationDescriptor;

  RotatingBitmap(BitmapData data, this.rotationDescriptor): super(data);

  bool advanceTime(num t) {
    rotationDescriptor.delta = t;
    rotation = rotation + rotationDescriptor.radians;
    return true;
  }
}