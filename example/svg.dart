import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'));
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  var resourceManager = new ResourceManager()
      ..addTextFile('image', 'image.svg')
      ..load().then((rm) {
        fromSvg(rm.getTextFile('image'), 100, 100).then((BitmapData bmd) {
          var bm = new Bitmap(bmd);
          stage.addChild(bm);
          // add little animation.
          juggler.tween(bm, 2)
              ..animate.x.to(stage.contentRectangle.width - bm.width)
              ..animate.y.to(stage.contentRectangle.height - bm.height);
        });
      }
  );
}