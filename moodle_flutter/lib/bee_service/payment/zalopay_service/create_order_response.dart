import 'dart:convert';
import 'dart:core';
import 'dart:async';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/environment.dart';
import 'package:moodle_flutter/bee_service/payment/zalopay_service/util.dart' as utils;
import 'package:http/http.dart' as http;
import 'package:sprintf/sprintf.dart';

class CreateOrderResponse {
  final String zptranstoken;
  final String orderurl;
  final double returncode;
  final String returnmessage;
  final double subreturncode;
  final String subreturnmessage;
  final String ordertoken;
  
  CreateOrderResponse(
      {this.zptranstoken, this.orderurl, this.returncode, this.returnmessage, this.subreturncode, this.subreturnmessage, this.ordertoken});

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    return CreateOrderResponse(
      zptranstoken: json['zp_trans_token'] as String,
      orderurl: json['order_url'] as String,
      returncode: double.tryParse(json['return_code'].toString()),
      returnmessage: json['return_message'] as String,
      subreturncode: double.tryParse(json['sub_return_code'].toString()),
      subreturnmessage: json['sub_return_message'] as String,
      ordertoken: json["order_token"] as String,
    );
  }
}

class ZaloPayService {
  static Future<CreateOrderResponse> getUrlPayment(int amount, int courseId) async {
    var data = await BaseServiceRequest.fetch(
        HttpMethod.POST,
        AppContext.ENVIRONMENT.PAYMENT_ZALOPAY_SERVICE +
            "/$courseId/${AppContext.user.userId}/$amount");
    return CreateOrderResponse.fromJson(data);
  }

  static Future<CreateOrderResponse> createOrderZPSB(int price) async {
    var header = new Map<String, String>();
    header["Content-Type"] = "application/x-www-form-urlencoded";

    var body = new Map<String, String>();
    body["app_id"] = Environment.appIdDemo;
    body["app_user"] = Environment.appUser;
    body["app_time"] = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();
    body["amount"] = price.toStringAsFixed(0);
    body["app_trans_id"] = utils.getAppTransId();
    body["embed_data"] = "{}";
    body["item"] = "[]";
    body["bank_code"] = utils.getBankCode();
    body["description"] = utils.getDescription(body["app_trans_id"]);

    var dataGetMac = sprintf("%s|%s|%s|%s|%s|%s|%s", [
      body["app_id"],
      body["app_trans_id"],
      body["app_user"],
      body["amount"],
      body["app_time"],
      body["embed_data"],
      body["item"]
    ]);
    body["mac"] = utils.getMacCreateOrder(dataGetMac);
    print("mac: ${body["mac"]}");

    http.Response response = await http.post(
      Uri.parse(AppContext.ENVIRONMENT.PAYMENT_ZALOPAY_SERVICE_SB),
      headers: header,
      body: body,
    );

    print("body_request: $body");
    if (response.statusCode != 200) {
      return null;
    }

    var data = jsonDecode(response.body);
    print("data_response: $data}");

    return CreateOrderResponse.fromJson(data);
  }
}