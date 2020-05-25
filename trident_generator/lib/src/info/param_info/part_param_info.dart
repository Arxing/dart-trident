import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class PartParamInfo extends ParamInfo {
  final String key;
  final String filename;

  PartParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
    this.filename,
    this.key,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
