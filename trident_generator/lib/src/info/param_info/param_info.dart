import 'package:dartpoet/dartpoet.dart';

export 'bin_param_info.dart';
export 'field_param_info.dart';
export 'header_map_param_info.dart';
export 'header_param_info.dart';
export 'part_param_info.dart';
export 'path_param_info.dart';
export 'query_map_param_info.dart';
export 'query_param_info.dart';
export 'raw_json_param_info.dart';
export 'raw_param_info.dart';
export 'content_type_param_info.dart';
export 'on_send_param_info.dart';
export 'on_receive_param_info.dart';

enum BodyKind { none, formData, multipart, raw, binary }

class ParamInfo {
  String paramName;
  TypeToken paramType;
  ParameterMode mode;
  bool isRequired;

  ParamInfo({
    this.paramName,
    this.paramType,
    this.mode,
    this.isRequired,
  });
}