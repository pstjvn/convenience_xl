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

        var bg1 = new Bitmap(_.getBitmapData('bg1'));

        var bg2 = new Bitmap(_.getBitmapData('bg2'))
            ..filters = [new BlurFilter(3,3)];

        var bg3 = new Bitmap(_.getBitmapData('bg3'))
            ..filters = [new BlurFilter(10, 10)];


        // Use cache to speed things up - it will create a new texture that
        // will be used directly instead of blurring at each frame.
        bg2.applyCache(0, 0, bg2.width.toInt(), bg2.height.toInt());
        bg3.applyCache(0, 0, bg3.width.toInt(), bg3.height.toInt());

        stage..addChild(bg1)..addChild(bg2)..addChild(bg3);

        var demo = new Demo()
            ..csm = new ConstantSpeedMovement(time: 20, distance: 500)
            .._1 = bg1
            .._2 = bg2
            .._3 = bg3;

        juggler.add(demo);
      }
  );
}

class Demo implements Animatable {
  Bitmap _1;
  Bitmap _2;
  Bitmap _3;
  ConstantSpeedMovement csm;

  Demo();

  bool advanceTime(num t) {
    csm.deltaTime = t;
    var plusx = csm.advancement;
    _1.x = _1.x + plusx * -1;
    _2.x = _2.x + (plusx * -2.2);
    _3.x = _3.x + (plusx * -4.5);
    if (_3.x.abs() > _3.width - _3.stage.contentRectangle.width) return false;
    return true;
  }
}

