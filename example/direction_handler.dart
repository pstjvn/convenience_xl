import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'));
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  var handler = new ArrowKeysHandler(stage);

  handler.onKeyPressed.listen((num rad) {
    print(handler.direction);
  });

  stage.focus = stage;
}