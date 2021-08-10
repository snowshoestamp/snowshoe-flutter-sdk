import 'package:flutter/gestures.dart';

class SnowShoeMultiTouchGesture extends MultiTapGestureRecognizer {
  late MultiTouchGestureRecognizerCallback onMultiTap;
  List<List<double>> data = <List<double>>[];
  var numberOfTouches = 0;
  int minNumberOfTouches = 0;

  SnowShoeMultiTouchGesture() {
    super.onTapDown = (pointer, details) => addTouch(pointer, details);
    super.onTapUp = (pointer, details) => removeTouch(pointer, details);
    super.onTapCancel = (pointer) => cancelTouch(pointer);
    super.onTap = (pointer) => captureDefaultTap(pointer);
  }

  void addTouch(int pointer, TapDownDetails details) {
    numberOfTouches++;
    var pointData = [details.globalPosition.dx, details.globalPosition.dy];
    data.add(pointData);
  }

  void removeTouch(int pointer, TapUpDetails details) {
    if (numberOfTouches == minNumberOfTouches) {
      onMultiTap(data);
    }

    data.clear();
    numberOfTouches = 0;
  }

  void cancelTouch(int pointer) {
    numberOfTouches = 0;
  }

  void captureDefaultTap(int pointer) {}

  @override
  set onTapDown(_onTapDown) {}

  @override
  set onTapUp(_onTapUp) {}

  @override
  set onTapCancel(_onTapCancel) {}

  @override
  set onTap(_onTap) {}

}
typedef MultiTouchGestureRecognizerCallback = void Function(List<List<double>> data);