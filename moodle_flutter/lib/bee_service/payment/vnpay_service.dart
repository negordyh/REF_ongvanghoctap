import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';

class VNPayService {
  static Future<String> getUrlPayment(int courseId, int amount) async {
    var url = await BaseServiceRequest.fetch(
        HttpMethod.POST,
        AppContext.ENVIRONMENT.PAYMENT_VNPAY_SERVICE +
            "/$courseId/${AppContext.user.userId}/$amount");
    return url.toString();
  }
}
