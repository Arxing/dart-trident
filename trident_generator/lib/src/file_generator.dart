import 'package:dartpoet/dartpoet.dart';
import 'package:named_mode/named_mode.dart';

import 'info/info.dart';

class FileGenerator {
  final ClassInfo root;
  static const _dioClientName = "_client";
  ClassSpec _classSpec;

  FileGenerator(this.root);

  String generate() {
    _classSpec = ClassSpec.build(
      renameTo__AnApple('${root.className}Impl'),
      superClass: TypeToken.ofFullName(root.className),
      properties: [PropertySpec.of(_dioClientName, type: TypeToken.ofFullName('Dio'))],
      constructorBuilder: (host) sync* {
        yield ConstructorSpec.normal(
          host,
          parameters: [ParameterSpec.indexed('dio', type: TypeToken.ofFullName('Dio'))],
          codeBlock: CodeBlockSpec.line('''
          $_dioClientName = dio ??
            Dio(
              BaseOptions(
                baseUrl: '${root.baseUrl}',
                headers: {
                  ${root.headers.entries.map((entry) => "'${entry.key}': '${entry.value}'").join(',\n')}
                },
              ),
            );
          '''),
        );
      },
    );
    root.methods.forEach((methodPackage) {
      _classSpec.methods.add(_buildMethod(methodPackage));
    });
    return DartFile.fromFileSpec(FileSpec.build(classes: [_classSpec])).outputContent();
  }

  MethodSpec _buildMethod(MethodInfo methodPackage) {
    MethodSpec methodSpec = MethodSpec.build(methodPackage.methodName);
    methodSpec.returnType = methodPackage.returnType;
    methodPackage.params.map((paramPackage) {
      List<MetaSpec> metas = paramPackage.isRequired ? [MetaSpec.ofInstance("required")] : [];
      switch (paramPackage.mode) {
        case ParameterMode.normal:
          return ParameterSpec.normal(paramPackage.paramName, type: paramPackage.paramType, metas: metas);
        case ParameterMode.indexed:
          return ParameterSpec.indexed(paramPackage.paramName, type: paramPackage.paramType, metas: metas);
        case ParameterMode.named:
          return ParameterSpec.named(paramPackage.paramName, type: paramPackage.paramType, metas: metas);
      }
      throw "IllegalState";
    }).forEach((spec) => methodSpec.parameters.add(spec));
    methodSpec.codeBlock = _buildMethodBody(methodPackage);
    return methodSpec;
  }

  CodeBlockSpec _buildMethodBody(MethodInfo methodInfo) {
    final _headersInstanceName = '_headers';
    final _queriesInstanceName = '_queries';
    final _dataInstanceName = '_data';
    var code = """
    ${methodInfo.extractHeadersCode(_headersInstanceName)}
    
    ${methodInfo.extractQueryParamsCode(_queriesInstanceName)}
    
    ${methodInfo.extractDataCode(_dataInstanceName)}
    
    return $_dioClientName.request(
      '${methodInfo.extractPath()}',
      queryParameters: $_queriesInstanceName,
      data: $_dataInstanceName,
      onSendProgress: ${methodInfo.onSendPram?.paramName},
      onReceiveProgress: ${methodInfo.onReceivePram?.paramName},
      options: Options(
        method: '${methodInfo.httpMethod}',
        headers: $_headersInstanceName,
        contentType: ${methodInfo.extractContentTypeCode()},
      ),
    ).then((response){
      return ${methodInfo.extractResponseCode()};
    });  
    """;
    return CodeBlockSpec.line(code);
  }
}
