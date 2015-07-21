import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'), 
      options: new StageOptions()..inputEventMode = InputEventMode.MouseAndTouch);
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  new TouchEventHandler(stage)
      ..onGesture.where((type) => type == EventHandler.TAP).listen(onTap);

  new MouseEventHandler(stage)
      // effectively kill all other events as we are listening only for tap anyway
      ..alwaysTap = true
      ..onGesture.where((type) => type == EventHandler.TAP).listen(onTap);


}

void onTap(int tap) {
  print('Tapped!');
}