import 'package:moodle_flutter/moodle/base_request.dart';

final String _funcName = "core_course_get_contents";

class CourseContentsResponse {
  final int id;
  final String name;
  final String summary;
  final int section;
  final List<Module> modules;

  CourseContentsResponse.fromJson(Map<String, dynamic> json, int _courseId)
      : id = json['id'],
        name = json['name'],
        summary = json['summary'],
        section = json['section'],
        modules = (json['modules'] as List)
            .map((e) => Module._fromJson(e, _courseId))
            .toList();
}

class Module {
  final int id;
  final int courseId;
  final String url;
  final String name;
  final String modName;
  final String modPlural;
  final String description;
  final int instance;

  /// ONLY USE FOR GAME
  Module.init(int newId, int newCourseId)
      : id = newId,
        courseId = newCourseId,
        url = "",
        name = "",
        modName = "",
        modPlural = "",
        description = "",
        instance = 0;

  Module._fromJson(Map<String, dynamic> json, int courseId)
      : id = json['id'],
        courseId = courseId,
        url = json['url'],
        name = json['name'],
        modName = json['modName'.toLowerCase()],
        modPlural = json['modPlural'.toLowerCase()],
        description = json['description'],
        instance = json['instance'];

  @override
  String toString() {
    return "id " + id.toString() +
        " courseId " + courseId.toString() +
        "url " + url +
        " name " + name +
        " modname " + modName +
        " modplural " + modPlural ;
        // " description " + description !description= null ? description : "";
  }
}

class CourseContentsRequest extends BaseRequest<List<CourseContentsResponse>> {
  final int _courseId;

  CourseContentsRequest(this._courseId) : super(_funcName) {
    super.requestData['courseId'.toLowerCase()] = _courseId;
  }

  @override
  List<CourseContentsResponse> fromJson(data) {
    return (data as List)
        .map((e) => CourseContentsResponse.fromJson(e, _courseId))
        .toList();
  }
}
