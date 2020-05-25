import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class BinParamInfo extends ParamInfo {
  BinParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired = false,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
