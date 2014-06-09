part of convenience_xl;


class ConstantSpeedMovement {

  num _velocity;
  num _totalDistance;
  num _totalTime;
  num _fragment;
  num _advancement;

  ConstantSpeedMovement({ time: 2.0, distance: 500}) {
    _totalDistance = distance;
    _totalTime = time;
    _velocity = time * distance;
    _fragment = distance / time;
  }

  set deltaTime(num time) {
    _advancement = time * _fragment;
  }

  get advancement => _advancement;

}


/**
 * Represents an image that is to be used as a background.
 *
 * The image is repeated if needed to cover the whole stage by default.
 *
 * Its x/y movement is also capped in order to simulate continuous movement
 */
class SpriteBackground extends Bitmap {

}
