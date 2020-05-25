part of 'extensions.dart';

extension ParameterExtension on ParameterElement {
  ConstantReader getAnnotationReader(Type type) {
    var annotation = TypeChecker.fromRuntime(type).firstAnnotationOf(this);
    if (annotation != null) return ConstantReader(annotation);
    return null;
  }

  bool hasAnnotation(Type type) => this.getAnnotationReader(type) != null;

  bool hasAnyAnnotation() => paramSupportAnnotations.any((kind) => this.hasAnnotation(kind));
}
