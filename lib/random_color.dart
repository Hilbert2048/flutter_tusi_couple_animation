import 'dart:math' as math;
import 'dart:ui';

class RandomColor {
  static Color random() =>
      Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
}