import 'package:flutter_test/flutter_test.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_request.dart';
import 'package:snowshoe_sdk_flutter/src/api/stamp_result.dart';
import 'package:snowshoe_sdk_flutter/src/on_stamp_listener.dart';
import 'package:snowshoe_sdk_flutter/src/repository/stamp_service.dart';

class Listener implements OnStampListener {
  @override
  void onStampRequestMade() {
    print("Stamp request made!!");
  }

  @override
  void onStampResult(StampResult? result) {
    print("Tapped good'${result?.stamp?.serial}'");
    print("Tapped error'${result?.error?.message}'");
  }

}
void main() {
  var apiKey = "YOUR_SNOWSHOE_API_KEY";
  test('get stamp with touch info 865843476341', ()  async {
    print("Starting test");
    var service = StampService(apiKey, Listener());
    List<List<double>> data = [
      [85.60546875, 474.0625],
      [292.67578125, 285.9912109375],
      [193.88671875, 276.77734375],
      [171.123046875, 470.087890625],
      [83.84765625, 384.6337890625]
    ];
    await service.getStampByTouchPoints(data);
    print("Ending test");
  });

  //EXPECTED RESULT BAD REQUEST
  test('get stamp with touch info wrong', ()  async {
    print("Starting test");
    var service = StampService(apiKey, Listener());
    List<List<double>> data = [
      [85.60546875, 474.0625],
      [2.67578125, 285.9912109375],
      [193.88671875, 276.77734375],
      [171.123046875, 470.087890625],
      [83.84765625, 384.6337890625]
    ];
    await service.getStampByTouchPoints(data);
    print("Ending test");
  });
}
