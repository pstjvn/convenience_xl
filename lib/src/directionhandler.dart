part of convenience_xl;


/**
 * Abstracts the arrow keys handling and provides broadcasting stream of
 * events with the current direction as the type.
 */
class ArrowKeysHandler {

  static int RIGHT = 0x01;
  static int BOTTOM = 0x02;
  static int LEFT = 0x04;
  static int TOP = 0x08;

  static Map<int, int> KEYS = new Map.from({
    37: LEFT,
    38: TOP,
    39: RIGHT,
    40: BOTTOM
  });

  int _state = 0x00;
  StreamController _stream = new StreamController.broadcast();

  ArrowKeysHandler(DisplayObjectContainer el) {
    el
        ..onKeyDown.listen((KeyboardEvent e) {
          if (KEYS.containsKey(e.keyCode)) {
            var _newState = KEYS[e.keyCode];
            if (_state & _newState == 0) {
              _state =  _state | _newState;
              _stream.add(radians);
            }
          }
        })
        ..onKeyUp.listen((KeyboardEvent e) {
          if (KEYS.containsKey(e.keyCode)) {
            var _newState = KEYS[e.keyCode];
            _state = _state & ~_newState;
            _stream.add(radians);
          }
        });
  }

  /// Getter for the event tream with keys press changes.
  Stream<num> get onKeyPressed {
    return _stream.stream;
  }

  /// For debug only, returns named direction.
  String get direction {
    switch (_state) {
      case 0:
        return null;
      case 6:
        return 'rightdown';
      case 2:
        return 'down';
      case 3:
        return 'downleft';
      case 4:
        return 'left';
      case 12:
        return 'lefttop';
      case 8:
        return 'top';
      case 9:
        return 'topright';
      case 1:
        return 'right';
      default:
        return null;
    }
  }

  /// Getter for the current declination in radians.
  num get radians {
    switch (_state) {
      case 0:
        return null;
      case 6:
        return PI * 1 / 4;
      case 2:
        return PI * 2 / 4;
      case 3:
        return PI * 3 / 4;
      case 4:
        return PI * 1;
      case 12:
        return PI * 5 / 4;
      case 8:
        return PI * 6 / 4;
      case 9:
        return PI * 7 / 4;
      case 1:
        return PI * 2;
      default:
        return null;
    }
  }
}
