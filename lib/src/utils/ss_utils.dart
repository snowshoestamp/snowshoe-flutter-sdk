import 'package:built_value/json_object.dart';
import 'package:logger/logger.dart';

class SSUtils {
  static const String _sdkVersion = "3.1.2";
  static const String _tag = "SSUtils";
  static const String _testBaseUrl = "https://ss-dev-api-stamp.azurewebsites.net/v3";
  static const String _prodBaseUrl = "https://api.snowshoestamp.com/v3";
  static bool returnFromReport = true;
  static bool isProdUrl = true;
  static bool loggingOn = false;
  static Logger logger = Logger();

  static String getBaseUrl() => isProdUrl ? _prodBaseUrl : _testBaseUrl;
  static String getSdkVersion() => _sdkVersion;

  static void printJSONLog(bool isRequest, String json) {
    if (loggingOn) {
      if(isRequest) {
        logger.e("JSON", "TYPE OF MESSAGE: SENDING REQUEST ===>");
      } else {
        logger.e("JSON", "TYPE OF MESSAGE: SERVER RESPONSE ===>");
      }

      try {
        JsonObject jsonObject = JsonObject(json);
        logger.e("JSON", jsonObject.toString());
      } on Exception catch (e) {
          try {
            List jsonArray = JsonObject(json) as List;
            logger.e("JSON", jsonArray.toString());
          } on Exception catch (_) {
            logger.e("JSON", "ERROR PARSING JSON, INVALID JSON.");
          }
      }
    }
  }
}