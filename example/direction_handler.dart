import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'));
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  var rm = new ResourceManager()
      ..addBitmapData('arrow', 'arrow.png')
      ..load().then((_) {
        var a = new Bitmap(_.getBitmapData('arrow'));
        a
            ..pivotX = a.width / 2
            ..pivotY = a.height / 2
            ..x = a.pivotX
            ..y = a.pivotY;
        stage.addChild(a);
        var handler = new ArrowKeysHandler(stage);
        handler.onKeyPressed.listen((num rad) {
          a.rotation = rad;
        });
        stage.focus = stage;
      }
  );
}