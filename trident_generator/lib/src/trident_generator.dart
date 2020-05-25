import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:source_gen/source_gen.dart';
import 'package:trident/trident.dart';

import 'file_generator.dart';
import 'info/info.dart';
import 'extensions/extensions.dart';
import 'annotation_checker.dart';

class TridentGenerator extends GeneratorForAnnotation<Trident> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {


    if (element.kind != ElementKind.CLASS) return null;
    ClassElement classElement = element;
    checkAll(classElement);

    String className = classElement.name;
    String baseUrl = annotation.peek("baseUrl")?.stringValue ?? null;

    ClassInfo classPackage = ClassInfo(
      className: className,
      baseUrl: baseUrl,
      headers: classElement.extractConstantHeaders(),
    );
    classElement.methods.where((methodElement) => methodElement.hasHttpAnnotation()).forEach((methodElement) {
      MethodInfo methodPackage = MethodInfo(
        methodName: _getMethodName(methodElement),
        returnType: _getReturnType(methodElement),
        path: _getPath(methodElement),
        httpMethod: _getHttpMethod(methodElement),
        headers: methodElement.extractConstantHeaders(),
        queries: methodElement.extractConstantQueries(),
        params: methodElement.extractParams(),
        contentType: methodElement.extractContentType(),
      );
      classPackage.methods.add(methodPackage);
    });
    return FileGenerator(classPackage).generate();
  }

  String _getMethodName(MethodElement element) {
    return element.name;
  }

  TypeToken _getReturnType(MethodElement element) {
    return TypeToken.ofFullName(element.returnType.toString());
  }

  String _getHttpMethod(MethodElement element) {
    return element.getHttpAnnotation().peek('method')?.stringValue;
  }

  String _getPath(MethodElement element) {
    return element.getHttpAnnotation().peek('path')?.stringValue;
  }
}
