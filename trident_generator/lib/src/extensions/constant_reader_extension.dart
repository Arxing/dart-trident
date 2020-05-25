part of 'extensions.dart';

extension ConstantReaderExtension on ConstantReader {
  String castStringValue() {
    if (this.isNull) return null;
    if (this.isInt) return this.intValue.toString();
    if (this.isDouble) return this.doubleValue.toString();
    if (this.isBool) return this.boolValue.toString();
    if (this.isString) return this.stringValue.toString();
    if (this.isMap) {
      var map = this.mapValue.map(_mapMapper);
      return jsonEncode(map);
    }
    if (this.isList) {
      var list = this.listValue.map((o) => o.castStringValue()).toList();
      return jsonEncode(list);
    }
    throw "Unsupported type";
  }
}
