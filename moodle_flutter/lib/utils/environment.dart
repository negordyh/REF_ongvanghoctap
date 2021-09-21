class Environment {
  const Environment();

  String get HOST => "http://192.168.137.1/moodle";
  String get HOST_SERVICE => "moodle_mobile_app";
  String get AUTH_SERVICE => "authenticate";
  String get SERVICCE_AUTHENTICATE_TOKEN => "199fa14482d636466e6ee15d8d2654fc";
  String get FORMAT_API_RESPONSE => "json";

  String get BEE_SERVICE_IP => "http://35.219.44.37:8080";//192.168.137.1:8080";
  String get BEE_SERVICE_URL => BEE_SERVICE_IP + "/bee-api";
  String get COURSE_SERVICE => "/courses";
  String get LOG_USER => "/log-user";
  String get COURSE_USER_SERVICE => "/course-users";
  String get PAYMENT_VNPAY_SERVICE => "/payment-vnpay";
  String get PAYMENT_ZALOPAY_SERVICE => "/payment-zalopay";
  String get PAYMENT_ZALOPAY_SERVICE_SB => "https://sb-openapi.zalopay.vn/v2/create";

  ///Zalopay config Demo App
  static const String appIdDemo = "2553";
  static const String key1Demo = "PcY4iZIKFCIdgZvA6ueMcMHHUbRLYjPL";
  static const String key2Demo = "kLtgPl8HHhfvMuDHPwKfgfsY4Ydm9eIz";
  static const String appUser = "zalopaydemo";
  static int transIdDefault = 1;

  ///Zalopay config Sb Account App
  static const String appIdSb = "2554";
  static const String key1Sb = "sdngKKJmqEMzvh5QQcdD2A9XBSKUNaYn";
  static const String key2Sb = "trMrHtvjo6myautxDUiAcYsVtaeQ8nhf";
}

class Local extends Environment {
  const Local();
  String get HOST => "http://192.168.137.1/moodle";
  String get SERVICCE_AUTHENTICATE_TOKEN => "199fa14482d636466e6ee15d8d2654fc";
}

class OngVang extends Environment {
  const OngVang();
  String get HOST => "ongvanghoctap.edu.vn";
  String get SERVICCE_AUTHENTICATE_TOKEN => "a2d8ff921a005047905999c2a87dcd07";
}
