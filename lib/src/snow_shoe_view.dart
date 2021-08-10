import 'package:flutter/widgets.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_result.dart';
import 'package:snowshoe_sdk_flutter/src/repository/stamp_service.dart';
import 'package:snowshoe_sdk_flutter/src/snow_shoe_multi_touch_gesture.dart';

import 'on_stamp_listener.dart';

class SnowShoeView extends StatelessWidget implements OnStampListener {
  static const String routeName = "/snow_shoe_view";
  static const int numberOfStampPts = 5;

  late final OnStampListener onStampListener;
  late final String apiKey;
  late final StampService _stampService;

  bool _stampBeingChecked = false;

  SnowShoeView({Key? key}) : super(key: key) {
    _stampService = StampService(apiKey, this);
  }

  SnowShoeView.secondary(this.onStampListener, this.apiKey, {Key? key}) : super(key: key) {
    _stampService = StampService(apiKey, this);
  }

  void setOnStampListener(OnStampListener listener) {
    onStampListener = listener;
  }

  void setApiKey(String key) {
    apiKey = key;
  }

  void onTap(List<List<double>> data) {
    if(!_stampBeingChecked) {
      _stampBeingChecked = true;
      _stampService.getStampByTouchPoints(data);
    }

    print("Tapped with '${data.length}' finger(s)");
    print("1 - ${data[0][0]}, ${data[0][1]}");
    print("2 - ${data[1][0]}, ${data[1][1]}");
    print("3 - ${data[2][0]}, ${data[2][1]}");
    print("4 - ${data[3][0]}, ${data[3][1]}");
    print("5 - ${data[4][0]}, ${data[4][1]}");
  }


  @override
  void onStampRequestMade() {
    onStampListener.onStampRequestMade();
  }

  @override
  void onStampResult(StampResult? result) {
    if(result != null) {
      onStampListener.onStampResult(result);
    }
    _stampBeingChecked = false;
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
        gestures: <Type, GestureRecognizerFactory>{
          SnowShoeMultiTouchGesture: GestureRecognizerFactoryWithHandlers<SnowShoeMultiTouchGesture>(
                () => SnowShoeMultiTouchGesture(),
                (SnowShoeMultiTouchGesture instance) {
                  instance.minNumberOfTouches = 5;
                  instance.onMultiTap = (data) => onTap(data);
                })
        }
      );
  }
}