part of 'extensions.dart';

extension ClassElementExtension on ClassElement {
  Map<String, String> extractConstantHeaders() {
    var map = <String, String>{};
    TypeChecker.fromRuntime(HeaderMap).annotationsOf(this).forEach((headers) {
      ConstantReader(headers).peek("headers").mapValue.forEach((key, value) {
        var mapKey = key.toStringValue();
        var mapVal = value.castStringValue();
        map[mapKey] = mapVal;
      });
    });

    TypeChecker.fromRuntime(Header).annotationsOf(this).forEach((header) {
      var reader = ConstantReader(header);
      var key = reader.peek('key')?.stringValue;
      var value = reader.peek('value')?.castStringValue();
      map[key] = value;
    });
    return map;
  }
}
