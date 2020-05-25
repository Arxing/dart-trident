import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class ContentTypeParamInfo extends ParamInfo {
  final String contentType;

  ContentTypeParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
    this.contentType,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
