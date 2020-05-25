import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class PathParamInfo extends ParamInfo {
  final String key;

  PathParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
    this.key,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
