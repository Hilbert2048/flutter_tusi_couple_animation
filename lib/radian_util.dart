import 'dart:math';

class RadianUtils {
  static double radianToAngle(double radian) {
    return radian * 180 / (pi);
  }
  static double angleToRadian(double angle) {
    return angle * pi / 180;
  }
}
