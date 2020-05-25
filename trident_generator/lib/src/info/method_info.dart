import 'package:dartpoet/dartpoet.dart';

import 'info.dart';

class MethodInfo {
  String methodName;
  TypeToken returnType;
  String httpMethod;
  String path;
  Map<String, String> headers;
  Map<String, String> queries;
  List<ParamInfo> params;
  String contentType;

  MethodInfo({
    this.methodName,
    this.returnType,
    this.httpMethod,
    this.path,
    this.contentType,
    Map<String, String> headers,
    Map<String, String> queries,
    List<ParamInfo> params,
  }) {
    this.headers = headers ?? {};
    this.queries = queries ?? {};
    this.params = params ?? [];
  }

  List<FieldParamInfo> get fieldParams => params.whereType<FieldParamInfo>().toList();

  List<PartParamInfo> get partParams => params.whereType<PartParamInfo>().toList();

  List<RawParamInfo> get rawParams => params.whereType<RawParamInfo>().toList();

  List<RawJsonParamInfo> get rawJsonParams => params.whereType<RawJsonParamInfo>().toList();

  List<BinParamInfo> get binParams => params.whereType<BinParamInfo>().toList();

  ContentTypeParamInfo get contentTypeParam => params.whereType<ContentTypeParamInfo>().firstWhere((_) => true, orElse: () => null);

  OnSendParamInfo get onSendPram => params.whereType<OnSendParamInfo>().firstWhere((_) => true, orElse: () => null);

  OnReceiveParamInfo get onReceivePram => params.whereType<OnReceiveParamInfo>().firstWhere((_) => true, orElse: () => null);

  BodyKind get bodyKind {
    var guessFormData = fieldParams.isNotEmpty;
    var guessMultipart = partParams.isNotEmpty;
    var guessRaw = rawParams.isNotEmpty || rawJsonParams.isNotEmpty;
    var guessBin = binParams.isNotEmpty;
    if (guessFormData) {
      if (guessMultipart || guessRaw || guessBin) throw "All annotation must be @Field If use form-data. In method $methodName.";
      return BodyKind.formData;
    }
    if (guessMultipart) {
      if (guessFormData || guessRaw || guessBin) throw "All annotation must be @Part If use form-data. In method $methodName.";
      return BodyKind.multipart;
    }
    if (guessRaw) {
      if (guessMultipart || guessFormData || guessBin)
        throw "All annotation must be @Raw or @RawJson If use form-data. In method $methodName.";
      return BodyKind.raw;
    }
    if (guessBin) {
      if (guessMultipart || guessRaw || guessFormData) throw "All annotation must be @Bin If use form-data. In method $methodName.";
      return BodyKind.binary;
    }
    return BodyKind.none;
  }

  String extractPath() {
    var result = path;
    params.whereType<PathParamInfo>().forEach((param) {
      result = result.replaceAll('{${param.key}}', '\$${param.paramName}');
    });
    return result;
  }

  String extractHeadersCode(String instance) {
    var pairs = [];
    headers.entries.map((entry) => "'${entry.key}': '${entry.value}'").forEach((pair) => pairs.add(pair));
    params.whereType<HeaderParamInfo>().map((param) => "'${param.key}': ${param.paramName}").forEach((pair) => pairs.add(pair));
    return """
    final $instance = <String, dynamic>{
      ${pairs.join(',\n')} 
    };
    ${params.whereType<HeaderMapParamInfo>().map((param) => "${param.paramName}.forEach((k, v) => $instance[k] = v);").join("\n")}
    $instance.removeWhere((k, v) => v == null);
    """;
  }

  String extractQueryParamsCode(String instance) {
    var pairs = [];
    queries.entries.map((entry) => "'${entry.key}': '${entry.value}'").forEach((pair) => pairs.add(pair));
    params.whereType<QueryParamInfo>().map((param) => "'${param.key}': ${param.paramName}").forEach((pair) => pairs.add(pair));
    return """
    final $instance = <String, dynamic>{
      ${pairs.join(',\n')} 
    };
    ${params.whereType<QueryMapParamInfo>().map((param) => "${param.paramName}.forEach((k, v) => $instance[k] = v);").join("\n")}
    $instance.removeWhere((k, v) => v == null);
    """;
  }

  String extractDataCode(String instance) {
    switch (bodyKind) {
      case BodyKind.none:
        break;
      case BodyKind.formData:
        return _extractFormDataDataCode(instance);
      case BodyKind.multipart:
        return _extractMultipartDataCode(instance);
      case BodyKind.raw:
        return _extractRawDataCode(instance);
      case BodyKind.binary:
        return _extractBinDataCode(instance);
    }
    return "final $instance = null;";
  }

  String extractContentTypeCode() {
    if (contentType != null) return contentType;
    if (contentTypeParam != null) return "'\$${contentTypeParam.paramName}'";
    switch (bodyKind) {
      case BodyKind.none:
        break;
      case BodyKind.formData:
        return "'application/x-www-form-urlencoded'";
      case BodyKind.multipart:
        return "'multipart/form-data'";
      case BodyKind.raw:
        return rawParams.single.contentType;
      case BodyKind.binary:
        break;
    }
    return null;
  }

  String extractResponseCode() {
    var type = returnType.firstGeneric;

    if (type.typeName == "Response") {
      return "response";
    } else if (type.typeName == "ResponseBody") {
      return "ResponseBody.fromString(response.data, response,statusCode)";
    } else if (type.typeName == "Stream" && type.hasGeneric && type.firstGeneric.typeName == "Uint8List") {
      return "ResponseBody.fromString(response.data, response.statusCode).stream";
    } else if (type.isPrimitive) {
      return "response.data";
    } else if (type.isVoid) {
      return "null";
    } else if (type.isList) {
      return "response.data.map((data)=>${type.firstGeneric.typeName}.fromJson(data as Map<String, dynamic>)).toList()";
    } else {
      return "${type.typeName}.fromJson(response.data)";
    }
  }

  String _extractMultipartDataCode(String instance) {
    var body = partParams.map((param) {
      String key = param.key;
      if (param.paramType.typeName == 'File') {
        // File
        var buffer = StringBuffer();
        buffer.write('MultipartFile.fromFileSync(${param.paramName}.path');
        if (param.filename != null)
          buffer.write(", filename: '${param.filename}')");
        else
          buffer.write(')');
        return "'$key': ${buffer.toString()}";
      } else if (param.paramType.isList && param.paramType.firstGeneric.typeName == 'File') {
        // List<File>
        var body = '${param.paramName}.map((file) => MultipartFile.fromFileSync(file.path)).toList()';
        return "'$key': $body";
      } else {
        if (param.paramType.isPrimitive) {
          return "'$key': ${param.paramName}";
        } else {
          return "'$key': jsonEncode(${param.paramName})";
        }
      }
    }).join(",\n");

    return """
    final $instance = FormData.fromMap({
      $body
    });
    """;
  }

  String _extractFormDataDataCode(String instance) {
    return """
    final $instance = {
      ${fieldParams.map((param) {
      var key = param.key;
      if (param.paramType.isPrimitive) {
        return "'$key': ${param.paramName}";
      } else {
        return "'$key': jsonEncode(${param.paramName})";
      }
    }).join(",\n")}
    };
    """;
  }

  String _extractRawDataCode(String instance) {
    if (rawParams.isNotEmpty) {
      var rawParam = rawParams.single;
      return """
      final $instance = ${rawParam.paramName}; 
      """;
    }
    if (rawJsonParams.isNotEmpty) {
      var jsonBody = rawJsonParams.map((param) {
        return "'${param.key}': ${param.paramName}";
      }).join(',\n');
      var json = "{$jsonBody}";

      return """
      final $instance = jsonEncode($json);
      """;
    }
    return 'final $instance = null;';
  }

  String _extractBinDataCode(String instance) {
    var binParam = binParams.single;
    return """
    final $instance = Stream.fromIterable(${binParam.paramName}.map((e) => [e]));
    """;
  }
}
