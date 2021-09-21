import 'package:moodle_flutter/moodle/base_request.dart';

final String _funcName =
    "core_course_get_enrolled_courses_by_timeline_classification";

class CoursesEnrolledOfUser {
  final int id;
  final String shortName;
  final String fullName;
  final String displayName;
  final String imageUrl;
  final String summary;
  final bool visible;
  int price;
  int discount;
  final String coursecategory;
  final int startdate;
  final int enddate;
  final int progress;
  final bool hasprogress;
  final bool hidden;

  CoursesEnrolledOfUser.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        shortName = json['shortName'.toLowerCase()],
        fullName = json['fullName'.toLowerCase()],
        displayName = json['displayName'.toLowerCase()],
        imageUrl = json['imageUrl'.toLowerCase()] ?? json['courseimage'] ?? '',
        visible = json['visible'] == 1 ? true : false,
        summary = json['summary'],
        price = json['price'] ?? 0,
        discount = json['discount'] ?? 0,
        coursecategory = json['coursecategory'],
        startdate = json['startdate'],
        enddate = json['enddate'],
        progress = json['progress'],
        hasprogress =json['hasprogress'] is bool ? json['hasprogress'] : json['hasprogress'] == 1 ? true : false,
        hidden = json['hidden'] is bool ? json['hidden'] : json['hidden'] == 1 ? true : false;

  static Map<String, dynamic> toMap(CoursesEnrolledOfUser instance) => {
    'id': instance.id,
    'shortName'.toLowerCase(): instance.shortName,
    'fullName'.toLowerCase(): instance.fullName,
    'displayName'.toLowerCase(): instance.displayName,
    'imageUrl'.toLowerCase(): instance.imageUrl,
    'visible': instance.visible,
    'summary': instance.summary,
    'price': instance.price,
    'discount': instance.discount,
    'coursecategory': instance.coursecategory,
    'startdate': instance.startdate,
    'enddate': instance.enddate,
    'progress': instance.progress,
    'hasprogress': instance.hasprogress,
    'hidden': instance.hidden
  };

  @override
  String toString() =>
      'CoursesEnrolledOfUser:{${CoursesEnrolledOfUser.toMap(this)}}';
}

class CoursesEnrolledOfUserRequest
    extends BaseRequest<List<CoursesEnrolledOfUser>> {
  CoursesEnrolledOfUserRequest() : super(_funcName);

  Future<List<CoursesEnrolledOfUser>> getCoursesEnrolledOfUser() async {
    super.requestData['classification'] = 'inprogress';
    List<CoursesEnrolledOfUser> res = await super.fetch();
    // super.requestData['classification'] = 'past';
    // res.addAll(await super.fetch());
    if (res.isNotEmpty) logger.d('${res[0]}');
    return res;
  }

  @override
  List<CoursesEnrolledOfUser> fromJson(data) {
    return (data['courses'] as List)
        .map((e) => CoursesEnrolledOfUser.fromJson(e))
        .toList();
  }
}
