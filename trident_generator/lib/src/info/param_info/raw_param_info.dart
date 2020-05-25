import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class RawParamInfo extends ParamInfo {
  final String contentType;

  RawParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired = false,
    this.contentType,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
