import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class HeaderMapParamInfo extends ParamInfo {
  final Map<String, dynamic> headers;

  HeaderMapParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
    this.headers,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
