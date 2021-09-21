import 'package:moodle_flutter/bee_service/base_service_request.dart';
import 'package:moodle_flutter/utils/app_context.dart';

class CoursePrice {
  final int id;
  final int moodleCourseId;
  final int price;
  final int discount;
  final String name;

  CoursePrice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        moodleCourseId = json['moodleCourseId'],
        price = json['price'],
        discount = json['discount'],
        name = json['name'];
}

class CoursesPriceRequest {
  static Future<List<CoursePrice>> getAllCoursePrices() async {
    var data = (await BaseServiceRequest.fetch(HttpMethod.GET, AppContext.ENVIRONMENT.COURSE_SERVICE) as List);
    return data == null ? [] : data.map((e) => CoursePrice.fromJson(e)).toList();
  }
}
