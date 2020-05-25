import 'package:dartpoet/dartpoet.dart';
import 'param_info.dart';

class OnSendParamInfo extends ParamInfo {
  OnSendParamInfo({
    String paramName,
    TypeToken paramType,
    ParameterMode mode,
    bool isRequired,
  }) : super(
          paramName: paramName,
          paramType: paramType,
          mode: mode,
          isRequired: isRequired = false,
        );
}
