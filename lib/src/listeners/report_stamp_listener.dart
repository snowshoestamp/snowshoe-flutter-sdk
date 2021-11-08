import 'package:snowshoe_sdk_flutter/src/models/report_stamps_result.dart';

abstract class OnReportStampListener {
  void didReportStamp(ReportStampsResult result);
  void failedReportStamps(ReportStampsResult result);
}