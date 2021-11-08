import '../api/stamp_result.dart';
import '../models/snow_shoe_result.dart';

abstract class OnStampListener {
  void onGetSerialResult(SnowShoeResult? result);
  void onSyncCompleted(bool result);
}