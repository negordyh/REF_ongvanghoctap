import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/moodle/enroll/enrol_manual_enrol_users.dart';
import 'package:moodle_flutter/ui/components/alert_dialog.dart';

import 'app_context.dart';

class DynamicLinkService {

  static void retrieveDynamicLink(BuildContext context) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData dynamicLink) async {
            final Uri deepLink = dynamicLink?.link;

            if (deepLink != null) {
              logger.d(deepLink);
              validateLink(deepLink, context);
            }
          },
          onError: (OnLinkErrorException e) async {
            print('onLinkError');
            print(e.message);
          }
      );

      final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance
          .getInitialLink();
      final Uri deepLink = data?.link;
      if (deepLink != null) {
        logger.d(deepLink);
        validateLink(deepLink, context);
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  static void validateLink(Uri link, BuildContext  context) {
    logger.d(link.path);
    if (link.path.compareTo("/vnpay-payment") == 0) {
      Map map = {};
      for (var key in link.queryParameters.keys){
        map[key] = link.queryParameters[key];
      }
      validateCheckSumTransaction(map, context);
    }
  }

  static void validateCheckSumTransaction(Map queryParameters, BuildContext context) {
    logger.d(queryParameters);
    String vnp_SecureHash = queryParameters["vnp_SecureHash"];
    queryParameters.remove("vnp_SecureHashType");
    queryParameters.remove("vnp_SecureHash");

    Map vnp_Params = sortObject(queryParameters);

    var tmnCode = AppContext.vnp_TmnCode;
    var secretKey = AppContext.vnp_HashSecret;
    var signData = secretKey + stringify(vnp_Params);
    logger.d(signData);
    var checkSum = sha256.convert(utf8.encode(signData));
    logger.d(vnp_SecureHash);
    logger.d(checkSum);

    if(vnp_SecureHash == checkSum.toString()
        && "00".compareTo(vnp_Params['vnp_ResponseCode']) == 0) {
      List<dynamic> courseInfo = queryParameters['vnp_OrderInfo'].toString().split("-").toList();
      EnrolManualEnrolUsersRequest(int.parse(courseInfo[1])).fetchUsingTokenAdmin();

      logger.i('Payment success');
      Navigator.pop(context); //Until(context, ModalRoute.withName('/home'));
      Navigator.pushReplacementNamed(context, "/home");
      showDialog(
        context: context,
        builder: (context) =>
            CustomDialog(
              title: 'Payment success',
              description: 'Welcome to your course',
            ),
      );
    } else {
      logger.i('Payment failed');
      Navigator.pop(context); //Until(context, ModalRoute.withName('/home'));
      Navigator.pushReplacementNamed(context, "/home");
      showDialog(
        context: context,
        builder: (context) =>
            CustomDialog(
              title: 'Payment Failed',
              description: 'Oop!, Occurs error',
            ),
      );
    }
  }

  static Map sortObject(Map o) {
    var sorted = {},
        key,
        a = [];
    for (key in o.keys) {
      if (o.containsKey(key)) {
        a.add(key);
      }
    }
    a.sort();
    for (key = 0; key < a.length; key++) {
      sorted[a[key]] = o[a[key]];
    }
    return sorted;
  }

  static String stringify(Map vnp_params) {
    String res = "";
    for (var key in vnp_params.keys) {
      res += key.toString() + '=' + vnp_params[key] + '&';
    }
    return res.endsWith('&') ? res.substring(0,res.length - 1) : res;
  }
}