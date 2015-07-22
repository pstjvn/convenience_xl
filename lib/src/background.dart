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
  Background(this._fullSize) : super();

  @override
  void set bitmapData(BitmapData data) {

    num repeatStart = 0;

    BitmapData dest = new BitmapData(_fullSize.width.toInt(),
        _fullSize.height.toInt());

    dest.copyPixels(data, data.rectangle.align(), new Point(repeatStart, 0));

    int rx = (_fullSize.width / data.width).ceil();
    int ry = (_fullSize.height / data.height).ceil();

    if (repeatX && rx > 1) {
      for (var i = 1; i < rx; i++) {
        dest.copyPixels(data, data.rectangle.align(), new Point(i * data.width, 0));
      }
    }

    if (repeatY && ry > 1) {
      for (var i = 1; i < ry; i++) {
        if (repeatX) {
          for (var j = 0; j < rx; j++) {
            dest.copyPixels(data, data.rectangle.align(), new Point(j * data.width, i *
                data.height));
          }
        } else {
          dest.copyPixels(data, data.rectangle, new Point(0, i * data.height));
        }
      }
    }

    super.bitmapData = dest;
  }
}


/**
 * Automatically creates parallax background effects.
 *
 * The class expects to be configured with at least two [BitmapData] instances to
 * generate a parallax effect of movement. The sizes will be automatically
 * adjusted to the last image.
 *
 * Note that the order in which the images are listed is the order in which
 * they will be added to the stage, which means that the first image will be
 * the one on the higher depth in the view and the last one listed will be the
 * 'front' one.
 *
 * Also the last image is used as '1:1' calibration for the scalars, which means
 * that its x/y properties will be set exactly and the rest of the images will
 * be adjusted by the scalar value according to their sizes.
 *
 * For usage see the example [parallax.dart]
 */
class ParallaxBackground extends DisplayObjectContainer {

  List<num> _scalarX;
  List<num> _scalarY;
  List<Bitmap> _imageLayers = new List();

  ParallaxBackground() : super() {
    onAddedToStage.first.then((e) {
      _setScalars();
      x = x;
      y = y;
    });
  }

  void setLayers(List<BitmapData> layers) {
    _scalarX = new List(layers.length);
    _scalarY = new List(layers.length);
    layers.forEach((layer) {
      _imageLayers.add(new Bitmap()..bitmapData = layer);
      addChild(_imageLayers.last);
    });
  }

  void _setScalars() {
    var w = stage.contentRectangle.width;
    var h = stage.contentRectangle.height;

    var last = _imageLayers.length - 1;

    _scalarX[last] = 1;
    _scalarY[last] = 1;

    for (var i = 0; i < last; i++) {
      _scalarX[i] = (_imageLayers[last].width - w) / (_imageLayers[i].width - w);
      _scalarY[i] = (_imageLayers[last].height - h) / (_imageLayers[i].height - h);
    }
  }

  void set x(num value) {
    for (var i = 0; i < _imageLayers.length; i++) {
      _imageLayers[i].x = value / _scalarX[i];
    }
  }

  num get x => _imageLayers.last.x;

  void set y(num value) {
    for (var i = 0; i < _imageLayers.length; i++) {
      _imageLayers[i].y = value / _scalarY[i];
    }
  }

  num get y => _imageLayers.last.y;
}
