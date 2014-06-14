import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'), webGL: true);
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  var rm = new ResourceManager()
      ..addBitmapData('bg1', 'bg.jpg')
      ..addBitmapData('bg2', 'bg2.png')
      ..addBitmapData('bg3', 'bg3.png')
      ..load().then((_) {

        // Demoes the parallax background class
        var bg = new ParallaxBackground()
            ..setLayers(
              [
                _.getBitmapData('bg1'),
                // make it beautiful with blur filter
                _.getBitmapData('bg2')..applyFilter(new BlurFilter(3,3)),
                _.getBitmapData('bg3')..applyFilter(new BlurFilter(10, 10))
               ]);


        stage.addChild(bg);

        // Demoes the constrant speed movement class.
        // In this case a regular tween could have been used, but it is
        // still a demo of specifying the speed behaviour by time and
        // travveled distance (much easier to abstract the movement by
        // measureing it in seconds and pixels).
        var demo = new Demo(bg)
            ..csm = new ConstantSpeedMovement(time: 2, distance: 500);

        juggler.add(demo);

      }
  );
}

class Demo implements Animatable {

  ConstantSpeedMovement csm;
  DisplayObject _do;

  Demo(this._do);

  bool advanceTime(num t) {
    csm.deltaTime = t;
    if (_do.x.abs() + csm.advancement < _do.width - _do.stage.contentRectangle.width) {
      _do.x = _do.x - csm.advancement;
      return true;
    } else {
      return false;
    }
  }
}

