part of convenience_xl;



/**
 * Number generator for linear sequnecing.
 *
 * The main idea is that we want to receive constant flow of numbers in a
 * certain limit [min] and [max].
 *
 * The flow is only in one direction: from lower to higher. Once the limit
 * is reached the iterator is restarted and the next lowest number is
 * returned.
 *
 * One exception is handled in this class: when the produced next number is
 * exactly equal to the second number after the iteration cicle a 'zero'
 * additiona numbe ris generated.
 *
 * To better understand this here is an example:
 *
 *    var lng = new LinearNumberGenerator(min:0,max:2,step:1);
 *    var first = lng.next; // 1
 *    var second = lng.next; // 2
 *    var third = lng.next; // 0 - special case, should be 1 in linear sequence
 *
 * The reasoning behind this special case is handling multiple image spites
 * in a single image frame as used in stagexlhelpers.
 */
class LinearNumberGenerator {

  /// The minimum value, generated number will never be lower than that,
  num min;
  /// The maximum value, generated number will never be more than that.
  num max;
  /// The step to use to generate the next value.
  num step;

  num _value;

  LinearNumberGenerator({this.min: 0, this.max: 10, this.step: 1}) {
    reset();
  }

  /**
   * The next number in the configured linear sequence.
   */
  num get next {
    _value += step;
    if (_value > max) {
      var diff = _value - max;
      if (diff == step) diff = 0;
      _value = min + diff;
    }
    return _value;
  }

  /**
   * Resets the generator.
   *
   * The first number returned by calling the [next]
   * getter will be the same as when it was first called after the instance
   * creation.
   */
  void reset() {
    _value = min;
  }
}



/**
 * Number generatora that cycles between the minimum and maximum values and
 * back again.
 */
class CyclicNumberGenerator extends LinearNumberGenerator {

  bool _increment = true;

  CyclicNumberGenerator({min: 1, max: 10, step: 1}): super(min: min, max: max, step: step);

  num get next {
    if (_increment) {
      if (_value >= max) {
        _increment = false;
      }
    } else {
      if (_value <= min) {
        _increment = true;
      }
    }
    if (_increment) {
      _value += step;
    } else {
      _value -= step;
    }
    return _value;
  }

  /// Nulls out the current values to the initial state, making the object as a newly created one.
  @override
  void reset() {
    _increment = true;
    _value =  (min + max) / 2;
  }
}


/**
 * Abstracted method to work with digits.
 */
class Digits {

  SpriteSheet _digits;

  /**
   * Instanciates a digit collection. The digits should have equal sizes.
   * Can be horizontally or vertically spread on the sheet. The actual images
   * are assumed to be in the correct order, startgin from 0. The code assumes
   * the digits are also in one row/column.
   */
  Digits(BitmapData source) {
    int w = 0;
    int h = 0;
    if (source.width > source.height) {
      w = source.width ~/ 10;
      h = source.height;
    } else {
      w = source.width;
      h = source.height ~/ 10;
    }
    _digits = new SpriteSheet(source, w, h);
  }

  /// Overrides the '[]' operator to return one of the bitmaps for each digit.
  BitmapData operator [](int index) {
    if (index < 0 || index > 9) {
      throw new ArgumentError('There are only 10 digits!');
    }
    return _digits.frameAt(index);
  }
}


/**
 * Instances of this class can be used to represent any value constitued
 * only of digits.
 *
 * One possible exmaple for usage is displaying the game score.
 */
class Score extends Bitmap {

  /// The [Digits] instance to use to generate the bitmap data.
  Digits _digits;
  /// Cache of bitmaps for different length values. Each bitmap represents one length (1,2,3...).
  Map<int, BitmapData> bitmaps;
  /// The rectangle that represents the size of a single digit.
  Rectangle _digitRect;

  int _value = 0;

  /**
   * Creates a new instance of the class based off the [Digits] instance.
   *
   * The first value is 0 by default.
   */
  Score(this._digits): super() {
    bitmaps = new Map();
    _digitRect = new Rectangle(0, 0, _digits[0].width, _digits[0].height);
    value = 0;
  }

  /**
   * Setting value will aitomatically generate the bitmap
   * data to represent the value as texture.
   */
  void set value(int score) {
    _value = score;
    String s = score.toString();
    if (!bitmaps.containsKey(s.length)) {
      BitmapData data = new BitmapData(s.length * _digitRect.width,
          _digitRect.height);
      bitmaps[s.length] = data;
    }
    List<String> d = s.split('');
    for (int i = 0; i < d.length; i++) {
      bitmaps[s.length].copyPixels(_digits[int.parse(d[i])],
          _digitRect, new Point(i * _digitRect.width, 0));
    }
    bitmapData = bitmaps[s.length];
  }

  int get value {
    return _value;
  }
}


/**
 * Wraps the [Score] instance and centers it in a rectangle depending on
 * its size. The position is calculated with optional offsets on x and y.
 *
 * The centering can also be configured to use x or y or both directions.
 */
class CenteredScore extends Score {

  static final String HORIZONTAL = 'horizontal';
  static final String VERTICAL = 'vertical';
  static final String BOTH = 'both';

  /// The additional X offset to apply. Can be negative as well.
  int centerOffsetX = 0;
  /// The additional Y offset to apply. Can be negative.
  int centerOffsetY = 0;
  /// The ordinate(s) to center against.
  String centerMode = BOTH;
  /// The rectangle to center the [Bitmap] against.
  Rectangle outherBoundingRect;

  /// Overrides the default score constructor.
  CenteredScore(Digits d): super(d);

  /// Centers the content against the [Rectangle].
  void center() {
    if (outherBoundingRect == null) return;
    x = 0;
    y = 0;
    if (centerMode == BOTH || centerMode == HORIZONTAL) {
      x = (outherBoundingRect.width / 2) - (width / 2);
    }
    if (centerMode == BOTH || centerMode == VERTICAL) {
      y = (outherBoundingRect.height / 2) - (width / 2);
    }
    x += centerOffsetX;
    y += centerOffsetY;
  }

  @override
  void set value(int score) {
    super.value = score;
    center();
  }
}


/**
 * Aligns the numeric display to the right based on predefined number of
 * digits (positions) in the display.
 *
 * To use it just define the x position of the numeric representation bitmap
 * and bind to the aligner - it will tweak the x position according to the
 * length of the number.
 *
 * Example: if you have 3 digits number and the current value is 7 the number
 * will be aligned 2 digit lengths to the right.
 */
class RightAlign {

  /// Positions to be completed with empty space if value is less.
  int positions = 3;
  Digits digits;

  RightAlign(this.positions);

  /// Align X to a certain value based on the number of digits in the currently
  /// represented value
  num align(num value) {

    if (digits == null) {
      throw new StateError('No Digits instance set to calculate alignment for');
    }

    var len = value.toString().length;
    // no alignmnet needed as the value is bigger than anticipated
    if (len >= positions) return 0;
    else {
      return digits[0].width * (positions - len);
    }
  }
}


/**
 * Auto-aligning score.
 *
 * Takes into account the maximum score value and right adjusts the position
 * of the displayed score number.
 *
 * Can also be used as counter (a la 80's games).
 */
class AlignedScore extends Score {

  RightAlign alignment;

  AlignedScore(Digits d): super(d);

  /// Sets the maximum score so the alignment can be constructed.
  set maxScore(int val) {
    alignment = new RightAlign(val.toString().length)..digits = _digits;
  }

  @override
  set x(num val) {
    super.x = val + alignment.align(value);
  }
}
