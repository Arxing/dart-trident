part of 'extensions.dart';

extension DartObjectExtension on DartObject {
  String castStringValue() {
    var type = this.type;
    if (type.isDartCoreNull) return null;
    if (type.isDartCoreInt) return this.toIntValue().toString();
    if (type.isDartCoreDouble) return this.toDoubleValue().toString();
    if (type.isDartCoreBool) return this.toBoolValue().toString();
    if (type.isDartCoreString) return this.toStringValue().toString();
    if (type.isDartCoreMap) return jsonEncode(this.toMapValue().map(_mapMapper));
    if (type.isDartCoreList) return jsonEncode(this.toListValue().map((o) => o.castStringValue()).toList());
    if (type.isDartCoreSet) return jsonEncode(this.toSetValue().map((o) => o.castStringValue()).toList());
    throw "Unsupported type";
  }
}
