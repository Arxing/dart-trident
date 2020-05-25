import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class QueryMapParamInfo extends ParamInfo {
  final Map<String, dynamic> queries;
  final bool encoded;

  QueryMapParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
    this.queries,
    this.encoded,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
