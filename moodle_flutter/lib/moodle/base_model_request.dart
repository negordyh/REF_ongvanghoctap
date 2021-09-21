import 'package:moodle_flutter/moodle/base_request.dart';

abstract class BaseModel {
  final int slot;
  final String type;
  final int page;
  final String html;

  BaseModel(this.slot, this.type, this.page, this.html);

  BaseModel.fromResponse(BaseModel response)
      : slot = response.slot,
        type = response.type,
        page = response.page,
        html = response.html;
}

abstract class BaseModRequest<Response, Model> extends BaseRequest<Response> {
  BaseModRequest(String funcName) : super(funcName);

  Model fromResponse(Response response);
}
