import 'package:moodle_flutter/moodle/base_request.dart';

String _funcName = "mod_h5pActivity_get_h5pActivities_by_courses".toLowerCase();

class H5PActivityResponse {
  final int courseModule;
  final String fileUrl;

  H5PActivityResponse._fromJson(Map<String, dynamic> json)
      : courseModule = json['courseModule'.toLowerCase()],
        fileUrl = json['package'.toLowerCase()][0]['fileUrl'.toLowerCase()]
            .toString();
}

class H5PActivityRequest extends BaseRequest<H5PActivityResponse> {
  int _h5pCourseModule;

  H5PActivityRequest(int courseId, int h5pCourseModule) : super(_funcName) {
    super.requestData['courseIds[0]'.toLowerCase()] = courseId;
    this._h5pCourseModule = h5pCourseModule;
  }

  @override
  H5PActivityResponse fromJson(data) {
    List listH5pJson =
        (data as Map<String, dynamic>)['h5pActivities'.toLowerCase()] as List;
    return listH5pJson.map((e) => H5PActivityResponse._fromJson(e)).firstWhere(
        (element) => element.courseModule == _h5pCourseModule,
        orElse: () => null);
  }
}
