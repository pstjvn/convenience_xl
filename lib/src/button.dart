part of convenience_xl;



class Button extends DisplayObjectContainer {

  static int NORMAL = 0;
  static int HOVERED = 1;
  static int PRESSED = 2;

  Bitmap bitmap;
  List<BitmapData> bitmaps = new List(3);

  Button(): super() {
    bitmap = new Bitmap();
    addChild(bitmap);
    _bindEvents();
  }

  void _bindEvents() {


    if (Multitouch.supportsTouchEvents) {

      Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;

      onTouchBegin.listen((_) {
        _.stopPropagation();
        _setState(PRESSED);
      });

      onTouchEnd.listen((_) {
        _.stopPropagation();
        _setState(NORMAL);
      });

    } else {

      onMouseDown.listen((_) {
        _.stopPropagation();
        _setState(PRESSED);
      });

      onMouseUp.listen((_) {
        _.stopPropagation();
        _setState(NORMAL);
      });
    }
  }

  void _setState(int pressed) {
    bitmap.bitmapData = bitmaps[pressed];
  }

  void setButtonBitmap({state: 0, BitmapData data: null}) {

    bitmaps[state] = data;
    if (state == NORMAL) bitmap.bitmapData = data;
  }

}