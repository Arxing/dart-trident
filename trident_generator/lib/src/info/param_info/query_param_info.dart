import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class QueryParamInfo extends ParamInfo {
  final String key;
  final dynamic value;
  final bool encoded;

  QueryParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
    this.key,
    this.value,
    this.encoded,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
