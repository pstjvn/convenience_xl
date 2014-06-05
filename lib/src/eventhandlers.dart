part of convenience_xl;



/**
 * Generalized event handling class. It is not intented to be used directly.
 *
 * Instead use the TouchHandler or MouseHandler class in respect with your
 * target environment.
 */
class EventHandler {

  static final int TAP = 1;
  static final int SWIPE_TO_RIGHT = 2;
  static final int SWIPE_TO_LEFT = 3;
  static final int SWIPE_TO_TOP = 4;
  static final int SWIPE_TO_BOTTOM = 5;
  static final int LONG_PRESS = 6;
  static final int DOUBLE_TAP = 7;

  /// How many pixels should be considered as 'swipe' length.
  int swipeLengthTreshold = 100;

  /// How many milliseconds are the maximum time for a 'swipe'.
  int swipeMaxTime = 250;

  /// The pixels allowed to move before the tap cannot be considered a click.
  int tapTreshold = 7;

  /// If set to true the touchstart / mousedown event always produce a
  /// TAP event even if a gesture is recognized afterwards. This is usable in
  /// games where timeing is critical / fast paced games and the user will gain
  /// more control and bvetter experience without the ~100ms delay of 'touchend'.
  bool alwaysTap = false;


  int _startTime;
  int _endTime;
  num _startX;
  num _startY;
  num _currentX;
  num _currentY;

  StreamController _stream = new StreamController.broadcast();
  InteractiveObject target;

  int get siwpeLengthDeviation {
    return swipeLengthTreshold ~/ 2.5;
  }

  EventHandler(this.target);

  void handleStart(num x,num y) {
    _startTime = new DateTime.now().millisecondsSinceEpoch;
    _startX = x;
    _startY = y;
    if (alwaysTap) {
      _onTap();
    }
  }

  void handleMove(num x, num y) {
    _currentX = x;
    _currentY = y;
  }

  void handleEnd(num x, num y) {
    _endTime = new DateTime.now().millisecondsSinceEpoch;
    _currentX = x;
    _currentY = y;
    _checkType();
  }

  void _checkType() {
    var diffx = (_startX - _currentX).abs();
    var diffy = (_startY - _currentY).abs();
    var toRight = (_startX < _currentY);
    // Check for tap only if alwaysTap is false (otherwqise the tap will
    // be duplicated)
    if (!alwaysTap) {
      if (diffx < tapTreshold && diffy < tapTreshold) {
        _onTap();
      }
    }

    // Needs better detection (i.e. as soon as the rule is reached and not wait
    // for the end)

    if (_endTime - _startTime < swipeMaxTime
        && diffx > swipeLengthTreshold && diffy < siwpeLengthDeviation ) {
      _onSwipe(SWIPE_TO_RIGHT);
    }
  }

  Stream<num> get onGesture {
    return _stream.stream;
  }

  void _onTap() {
    _stream.add(TAP);
  }

  void _onSwipe(int swipeType) {
    _stream.add(swipeType);
  }

  void _onLongpress() {}
  void _onDoublepress() {}

  /// You need to implement this method if you extend the class. Each type
  /// handler must know how to clean the handlers depending on what it listens
  /// for.
  void cancel() {
    throw new UnimplementedError('This method should be overriden in handler classes!');
  }
}


/**
 * Abstract touch handler.
 *
 * Use this class if you want to listen for touch events and gestures
 * generated with touch on the desired target element in the game.
 *
 * Note that because of the restricted size of the phones swipes on
 * items different from the whole stage might not work as expected.
 */
class TouchEventHandler extends EventHandler {

  int _touchID = -1;
  List<StreamSubscription> _subscriptions = new List();

  TouchEventHandler(InteractiveObject o) : super(o) {
    _subscriptions
        ..add(target.onTouchBegin.listen(handleTouchStart))
        ..add(target.onTouchMove.listen(handleTouchMove))
        ..add(target.onTouchEnd.listen(handleTouchEnd));
  }

  void handleTouchStart(TouchEvent e) {
    if (_touchID == -1) {
      _touchID = e.touchPointID;
      handleStart(e.stageX, e.stageY);
    }
  }

  void handleTouchMove(TouchEvent e) {
    if (e.touchPointID == _touchID) {
      handleMove(e.stageX, e.stageY);
    }
  }

  void handleTouchEnd(TouchEvent e) {
    if (e.touchPointID == _touchID) {
      _touchID = -1;
      handleEnd(e.stageX, e.stageY);
    }
  }

  @override
  void cancel() {
    _subscriptions.forEach((StreamSubscription s) {
      s.cancel();
    });
  }
}

class MouseEventHandler extends EventHandler {

  bool isMouseDown = false;
  List<StreamSubscription> _subscriptions = new List();

  MouseEventHandler(InteractiveObject o): super(o) {
    _subscriptions
        ..add(target.onMouseDown.listen(handleMouseStart))
        ..add(target.onMouseMove.listen(handleMouseMove))
        ..add(target.onMouseUp.listen(handleMouseEnd));
  }

  void handleMouseStart(MouseEvent e) {
    isMouseDown = true;
    handleStart(e.stageX, e.stageY);
  }

  void handleMouseMove(MouseEvent e) {
    if (isMouseDown) {
      handleMove(e.stageX, e.stageY);
    }
  }

  void handleMouseEnd(MouseEvent e) {
    if (isMouseDown) {
      isMouseDown = false;
      handleEnd(e.stageX, e.stageY);
    }
  }

  @override
  void cancel() {
    _subscriptions.forEach((StreamSubscription s) {
      s.cancel();
    });
  }

}



/**
 * Abstracts the arrow keys handling and provides broadcasting stream of
 * events with the current direction measures in radians.
 *
 * The main usage would be in games that use the arrow keys for navigation.
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


  /**
   * The constructor accepts any display object container and binds
   * event listening to it.
   *
   * For those to be fired in StageXL the focus should be set on that
   * DisplayObject, for example:
   *
   *    stage.focus = stage
   */
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
