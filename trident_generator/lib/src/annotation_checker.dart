import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'extensions/extensions.dart';
import 'package:source_gen/source_gen.dart';
import 'package:trident/trident.dart';
import 'package:logging/logging.dart';
import 'package:useful_extension/useful_extension.dart';

Logger logger = Logger('Trident');

void runAssert(bool condition, String message) {
  if (!condition) {
    logger.severe(message);
    throw null;
  }
}

void checkAll(ClassElement e) {
  checkClass(e);
}

void checkClass(ClassElement e) {
  var name = "${e.name}";

  runAssert(e.onlyHaveOne(Trident), '$name can only declare one @Trident annotation.');
  runAssert(
    e.onlyHaveThereInSupport(classSupportAnnotations),
    '$name can only declare there annotations: $classSupportAnnotations.',
  );
  e.methods.forEach((methodElement) => checkMethod(e, methodElement));
}

void checkMethod(ClassElement c, MethodElement e) {
  var name = "${c.name}.${e.name}()";

  runAssert(e.haveAnyOfThere(httpMethodAnnotations), '$name must declare one of $httpMethodAnnotations.');
  runAssert(e.anyOfThereOnlyHaveOne(httpMethodAnnotations), '$httpMethodAnnotations can only declare One in $name.');
  runAssert(e.onlyHaveThereInSupport(methodSupportAnnotations), '$name can only declare there annotations: $methodSupportAnnotations.');
  runAssert(e.returnType.isDartAsyncFuture, 'Return type of $name must be a Future.');

  e.parameters.forEach((paramElement) => checkParameter(c, e, paramElement));
  var params = e.parameters;
  if (params.any((el) => el.has(Field))) {
    // guess form-data
    var valid = params.every((el) => el.onlyHaveThereIn([Field], [Field, Part, Raw, RawJson, Bin]));
    runAssert(valid, 'All annotation in parameters must be @Field if use form-data body.');
  } else if (params.any((el) => el.has(Part))) {
    // guess multipart
    var valid = params.every((el) => el.onlyHaveThereIn([Part], [Field, Part, Raw, RawJson, Bin]));
    runAssert(valid, 'All annotation in parameters must be @Part if use multipart body.');
  } else if (params.any((el) => el.has(Raw) || el.has(RawJson))) {
    // guess raw
    var valid = params.every((el) => el.onlyHaveThereIn([Raw, RawJson], [Field, Part, Raw, RawJson, Bin]));
    runAssert(valid, 'All annotation in parameters must be @Raw or @RawJson if use raw body.');
    if (params.any((el) => el.has(Raw))) {
      runAssert(params.where((el) => el.has(Raw)).length == 1, 'Only one @Raw can be declared if use raw body.');
      runAssert(params.every((el) => !el.has(RawJson)), 'If use @Raw then can not use @RawJson.');
    } else if (params.any((el) => el.has(RawJson))) {
      runAssert(
          params.every((el) => el.onlyHaveThereIn([RawJson], [RawJson, Raw])), 'If use @RawJson then all annotations must be @RawJson.');
    }
  } else if (params.any((el) => el.has(Bin))) {
    // guess binary
    var valid = params.every((el) => el.onlyHaveThereIn([Bin], [Field, Part, Raw, RawJson, Bin]));
    runAssert(valid, 'All annotation in parameters must be @Field if use binary body.');
    runAssert(params.where((el) => el.has(Bin)).length == 1, 'Only one @Bin can be declared if use binary body');
  }

  var contentTypeCount = e.getAnnotations(ContentType).length + e.parameters.where((el) => el.has(ContentType)).length;
  runAssert(contentTypeCount <= 1, '@ContentType can only be declared once.');
}

void checkParameter(ClassElement c, MethodElement m, ParameterElement e) {
  var name = "${c.name}.${m.name}(${e.toString()})";

  runAssert(e.onlyHaveThereInSupport(paramSupportAnnotations), '$name can only declare there annotations: $paramSupportAnnotations.');
  if (e.has(Bin)) {
    runAssert(e.type.isDartCoreList, '@Bin can only declare to List parameter.');
  }
  if(e.has(ContentType)){
    runAssert(e.type.isDartCoreString, '@ContentType can only declare to string parameter.');
  }
}

List<Type> guessSupportTypes(Element element) {
  List<Type> supports;
  switch (element.kind) {
    case ElementKind.CLASS:
      supports = classSupportAnnotations;
      break;
    case ElementKind.METHOD:
      supports = methodSupportAnnotations;
      break;
    case ElementKind.PARAMETER:
      supports = paramSupportAnnotations;
      break;
    default:
      throw 'Unhandled element kind';
  }
  return supports;
}

extension _ElementExt on Element {
  List<ConstantReader> getAnnotations(Type type) {
    return checker(type).annotationsOf(this).map((o) => ConstantReader(o)).toList();
  }

  List<Type> getAnnotationsInSupport() {
    return allSupportAnnotations.where((support) => checker(support).hasAnnotationOf(this)).toList();
  }

  List<Type> getAnnotationsIn(List<Type> types) {
    return types.where((support) => checker(support).hasAnnotationOf(this)).toList();
  }

  bool has(Type type) => checker(type).hasAnnotationOf(this);

  bool onlyHaveOne(Type type) => checker(type).annotationsOf(this).length == 1;

  bool onlyHaveOneOrZero(Type type) => checker(type).annotationsOf(this).length <= 1;

  bool haveAnyOfThere(List<Type> types) => types.any((type) => checker(type).hasAnnotationOf(this));

  bool notHaveThere(List<Type> types) => !types.any((type) => checker(type).hasAnnotationOf(this));

  bool onlyHaveThereInSupport(List<Type> types) => this.getAnnotationsInSupport().every((type) => types.contains(type));

  bool onlyHaveThereIn(List<Type> types, List<Type> supports) {
    return this.getAnnotationsIn(supports).every((type) => types.contains(type));
  }

  bool anyOfThereOnlyHaveOne(List<Type> types) => types.every((type) => this.onlyHaveOneOrZero(type));
}

TypeChecker checker(Type type) => TypeChecker.fromRuntime(type);
