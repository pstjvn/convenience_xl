part of convenience_xl;


/**
 * Abstraction that intends to describe a constantly rotating object in
 * one and same deirection (clockwise or counter-clockwise).
 *
 */
class RotationDescriptor {

  static num fullCycle = PI * 2;

  /// Sets the rotation direction.
  bool clockwise = true;

  /// Sets the time needed for a full spin cycle.
  num speed;

  num _pieces;

  /// Holds the last calculates rotation based on the delta time calls.
  num radians = 0;

  RotationDescriptor({this.speed: 180.0}) {
    _pieces = fullCycle / this.speed;
  }

  set delta(num d) {
    radians = _pieces * d;
    if (!clockwise) radians *= -1;
  }

}