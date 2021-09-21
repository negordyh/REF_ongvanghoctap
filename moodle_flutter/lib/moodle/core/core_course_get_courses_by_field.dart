import 'package:flutter/cupertino.dart';
import 'package:moodle_flutter/moodle/base_request.dart';

final String _funcName = "core_course_get_courses_by_field";
final RegExp _removeHtmlTagRegExp = new RegExp("<[^>]*>");
final RegExp _removeRegExp = new RegExp("\n|\r|&nbsp");

class CoursesByFieldResponse {
  final int id;
  final String shortName;
  final String fullName;
  final String displayName;
  final String imageUrl;
  final String summary;
  final bool visible;
  int price;
  int discount;
  final String categoryname;
  final List<String> contacts;
  final List<String> enrollmentmethods;

  CoursesByFieldResponse.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        shortName = json['shortName'.toLowerCase()],
        fullName = json['fullName'.toLowerCase()],
        displayName = json['displayName'.toLowerCase()],
        imageUrl =
            json['imageUrl'.toLowerCase()] ?? (json['overviewfiles'].length != 0
                ? json['overviewfiles'][0]['fileurl']
                : ''),
        visible = json['visible'] == 1 ? true : false,
        summary = json['summary'],
        price = json['price'] ?? 0,
        discount = json['discount'] ?? 0,
        categoryname = json['categoryname'],
        contacts = (json['contacts'] as List)
            .map((e) => e is Map ? e['fullname'].toString() : e.toString())
            .toList(),
        enrollmentmethods = (json['enrollmentmethods'] as List)
            .map((e) => e.toString())
            .toList();

  static Map<String, dynamic> toMap(CoursesByFieldResponse instance) => {
        'id': instance.id,
        'shortName'.toLowerCase(): instance.shortName,
        'fullName'.toLowerCase(): instance.fullName,
        'displayName'.toLowerCase(): instance.displayName,
        'imageUrl'.toLowerCase(): instance.imageUrl,
        'visible': instance.visible,
        'summary': instance.summary,
        'price': instance.price,
        'discount': instance.discount,
        'categoryname': instance.categoryname,
        'contacts': instance.contacts,
        'enrollmentmethods': instance.enrollmentmethods
      };

  @override
  String toString() =>
      'CoursesByFieldResponse:{${CoursesByFieldResponse.toMap(this)}}';
}

class CoursesByFieldRequest extends BaseRequest<List<CoursesByFieldResponse>> {
  CoursesByFieldRequest() : super(_funcName);

  @override
  List<CoursesByFieldResponse> fromJson(data) {
    return (data['courses'] as List)
        .skip(0)
        .map((e) => CoursesByFieldResponse.fromJson(e))
        .toList();
  }
}
