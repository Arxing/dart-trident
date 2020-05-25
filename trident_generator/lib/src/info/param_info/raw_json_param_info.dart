import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class RawJsonParamInfo extends ParamInfo {
  final String key;

  RawJsonParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired = false,
    this.key,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
