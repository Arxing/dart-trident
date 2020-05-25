import 'info.dart';

class ClassInfo {
  String className;
  String baseUrl;
  List<MethodInfo> methods;
  Map<String, String> headers;

  ClassInfo({
    this.className,
    this.baseUrl,
    Map<String, String> headers,
    List<MethodInfo> methods,
  }) {
    this.headers = headers ?? {};
    this.methods = methods ?? [];
  }
}
