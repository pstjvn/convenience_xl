import 'package:stagexl/stagexl.dart';
import 'package:convenience_xl/convenience_xl.dart';
import 'dart:html' show querySelector;

void main() {
  var stage = new Stage(querySelector('canvas'));
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;

  renderLoop.addStage(stage);

  new ResourceManager()
      ..addBitmapData('digits', 'digits.png')
      ..load().then((rm) {
        var couner = new Counter(new Digits(rm.getBitmapData('digits')))
          ..maxScore = 10000
          ..finalScore = 10000;

        stage.addChild(couner);
        juggler.add(couner);
      }
  );
}

/// Increment with 1 every frame.
class Counter extends AlignedScore implements Animatable {

  int finalScore = 0;

  Counter(Digits d) : super(d);

  bool advanceTime(num t) {
    value = value + 1;
    x = 0;
    if (value >= finalScore) return false;
    return true;
  }

}