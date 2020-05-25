import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:source_gen/source_gen.dart';
import 'package:trident/trident.dart';
import 'package:dartpoet/dartpoet.dart';
import 'package:trident_generator/src/info/info.dart';
import 'dart:convert';

part 'class_element_extension.dart';

part 'method_element_extension.dart';

part 'parameter_element_extension.dart';

part 'dart_object_extension.dart';

part 'constant_reader_extension.dart';

final httpMethodAnnotations = [
  GET,
  POST,
  PUT,
  HEAD,
  DELETE,
  PATCH,
  DOWNLOAD,
];

final classSupportAnnotations = [
  Trident,
  Header,
  HeaderMap,
];

final methodSupportAnnotations = [
  GET,
  POST,
  PUT,
  HEAD,
  DELETE,
  PATCH,
  DOWNLOAD,
  Header,
  HeaderMap,
  Query,
  QueryMap,
  ContentType,
];

final paramSupportAnnotations = [
  Header,
  HeaderMap,
  Query,
  QueryMap,
  Field,
  Path,
  Part,
  Raw,
  RawJson,
  Bin,
  ContentType,
  OnSend,
  OnReceive,
];

List<Type> get allSupportAnnotations {
  var list = <Type>[];
  list.addAll(httpMethodAnnotations);
  list.addAll(classSupportAnnotations);
  list.addAll(methodSupportAnnotations);
  list.addAll(paramSupportAnnotations);
  return list.toSet().toList();
}

MapEntry<String, String> Function(DartObject, DartObject) _mapMapper = (k, v) => MapEntry(k.toStringValue(), v.castStringValue());
