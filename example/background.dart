import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'));
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  var rm = new ResourceManager()
      ..addBitmapData('bg', 'backgroundtexture.png')
      ..load().then((_) {
        // load 250x250 pixels background image to cover the whole stage.
        var bg = new Background(stage.contentRectangle)
            ..bitmapData = _.getBitmapData('bg');

        stage.addChild(bg);

  });
}