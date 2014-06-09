part of convenience_xl;


/**
 * Provides abstraction for creating background images to cover the stage.
 *
 * Imitates the behaviour of the backgroundImage CSS property.
 */
class Background extends Bitmap {

  Rectangle _fullSize;
  bool repeatX = true;
  bool repeatY = true;

  /// Creates a new instance that has the desired size. Upon setting the bitmap
  /// data it will be repeated (if allowed) to cover the whole area of the
  /// desired rectangle. The image data is assumed to be coherent when repeated.
  Background(this._fullSize): super();

  @override
  void set bitmapData(BitmapData data) {

    num repeatStart = 0;

    BitmapData dest = new BitmapData(
        _fullSize.width.toInt(),
        _fullSize.height.toInt());

    dest.copyPixels(data, data.rectangle, new Point(repeatStart, 0));

    int rx = (_fullSize.width / data.width).ceil();
    int ry = (_fullSize.height / data.height).ceil();

    if (repeatX && rx > 1) {
      for (var i = 1; i < rx; i++) {
        dest.copyPixels(data, data.rectangle, new Point(i * data.width, 0));
      }
    }

    if (repeatY && ry > 1) {
      for (var i = 1; i < ry; i++) {
        if (repeatX) {
          for (var j = 0; j < rx; j++) {
            dest.copyPixels(data, data.rectangle, new Point(j * data.width, i * data.height));
          }
        } else {
          dest.copyPixels(data, data.rectangle, new Point(0, i * data.height));
        }
      }
    }

    super.bitmapData = dest;
  }
}


