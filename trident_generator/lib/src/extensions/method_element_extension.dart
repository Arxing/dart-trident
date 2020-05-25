part of 'extensions.dart';

extension MethodElementExtension on MethodElement {
  TypeChecker _checker(Type type) => TypeChecker.fromRuntime(type);

  ConstantReader getHttpAnnotation() {
    for (var type in httpMethodAnnotations) {
      var annotation = _checker(type).firstAnnotationOf(this);
      if (annotation != null) return ConstantReader(annotation);
    }
    return null;
  }

  bool hasHttpAnnotation() => this.getHttpAnnotation() != null;

  Map<String, String> extractConstantHeaders() {
    var map = <String, String>{};
    _checker(HeaderMap).annotationsOf(this).forEach((headers) {
      ConstantReader(headers).peek("headers").mapValue.forEach((key, value) {
        var mapKey = key.castStringValue();
        var mapVal = value.castStringValue();
        map[mapKey] = mapVal;
      });
    });

    _checker(Header).annotationsOf(this).forEach((header) {
      var reader = ConstantReader(header);
      var key = reader.peek('key')?.stringValue;
      var value = reader.peek('value')?.stringValue;
      map[key] = value;
    });
    return map;
  }

  Map<String, String> extractConstantQueries() {
    var map = <String, String>{};
    _checker(QueryMap).annotationsOf(this).forEach((queries) {
      var reader = ConstantReader(queries);
      bool encoded = reader.peek('encoded').boolValue;
      reader.peek('queries').mapValue.forEach((k, v) {
        var key = k.toStringValue();
        var val = encoded ? Uri.encodeQueryComponent(v.castStringValue()) : v.castStringValue();
        map[key] = val;
      });
    });

    _checker(Query).annotationsOf(this).forEach((header) {
      var reader = ConstantReader(header);
      var key = reader.peek('key')?.stringValue;
      var val = reader.peek('value')?.castStringValue();
      bool encoded = reader.peek('encoded').boolValue;
      map[key] = encoded ? Uri.encodeComponent(val) : val;
    });
    return map;
  }

  String extractContentType() {
    var contentTypes = _checker(ContentType).annotationsOf(this).toList();
    if (contentTypes.isEmpty) return null;
    var reader = ConstantReader(contentTypes.single);
    return reader.peek('contentType').stringValue;
  }

  List<ParamInfo> extractParams() {
    return this.parameters.where((paramElement) => paramElement.hasAnyAnnotation()).map((paramElement) {
      var paramName = paramElement.name;

      print('${paramElement.type.displayName}');

      var paramType = TypeToken.ofFullName(paramElement.type.toString());
      var paramMode = paramElement.isOptionalNamed
          ? ParameterMode.named
          : paramElement.isOptionalPositional ? ParameterMode.indexed : ParameterMode.normal;
      bool isRequired = paramElement.hasRequired;

      for (var type in paramSupportAnnotations) {
        if (paramElement.hasAnnotation(type)) {
          var reader = paramElement.getAnnotationReader(type);
          switch (type) {
            case Header:
              var key = reader.peek('key').stringValue;
              var value = reader.peek('value')?.castStringValue();
              return HeaderParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                key: key,
                value: value,
                isRequired: isRequired,
              );
            case HeaderMap:
              var headers = reader.peek('headers')?.mapValue?.map(_mapMapper);
              return HeaderMapParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                headers: headers,
                isRequired: isRequired,
              );
            case Query:
              var key = reader.peek('key').stringValue;
              var value = reader.peek('value')?.castStringValue();
              var encoded = reader.peek('encoded').boolValue;
              return QueryParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                key: key,
                value: value,
                encoded: encoded,
                isRequired: isRequired,
              );
            case QueryMap:
              var queries = reader.peek('queries')?.mapValue?.map(_mapMapper);
              var encoded = reader.peek('encoded').boolValue;
              return QueryMapParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                queries: queries,
                encoded: encoded,
                isRequired: isRequired,
              );
            case Field:
              var key = reader.peek('key').stringValue;
              return FieldParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                key: key,
                isRequired: isRequired,
              );
            case Path:
              var key = reader.peek('key').stringValue;
              return PathParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                key: key,
                isRequired: isRequired,
              );
            case Part:
              var key = reader.peek('key').stringValue;
              var filename = reader.peek('filename')?.stringValue;
              return PartParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                key: key,
                filename: filename,
                isRequired: isRequired,
              );
            case Raw:
              var contentType = reader.peek('rawType').peek('contentType').stringValue;
              return RawParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                isRequired: isRequired,
                contentType: contentType,
              );
            case RawJson:
              var key = reader.peek('key').stringValue;
              return RawJsonParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                isRequired: isRequired,
                key: key,
              );
            case Bin:
              return BinParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                isRequired: isRequired,
              );
            case ContentType:
              var contentType = reader.peek('contentType')?.stringValue;
              return ContentTypeParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                isRequired: isRequired,
                contentType: contentType,
              );
            case OnSend:
              return OnSendParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                isRequired: isRequired,
              );
            case OnReceive:
              return OnReceiveParamInfo(
                paramName: paramName,
                paramType: paramType,
                mode: paramMode,
                isRequired: isRequired,
              );
          }
        }
      }
      return null;
    }).toList();
  }
}
