import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class HeaderParamInfo extends ParamInfo {
  final String key;
  final dynamic value;

  HeaderParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
    this.key,
    this.value,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
