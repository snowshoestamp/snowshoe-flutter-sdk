import 'api/stamp_result.dart';

abstract class OnStampListener {
  void onStampRequestMade();
  void onStampResult(StampResult? result);
}