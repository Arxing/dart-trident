import 'package:meta/meta.dart';

class HttpMethods {
  HttpMethods._();

  static const String GET = 'GET';
  static const String POST = 'POST';
  static const String PUT = 'PUT';
  static const String HEAD = 'HEAD';
  static const String DELETE = 'DELETE';
  static const String PATCH = 'PATCH';
  static const String DOWNLOAD = 'DOWNLOAD';

  static const List<String> METHODS = [
    GET,
    POST,
    PUT,
    HEAD,
    DELETE,
    PATCH,
    DOWNLOAD,
  ];
}

@immutable
class Trident {
  final String baseUrl;

  const Trident({this.baseUrl});
}

@immutable
class HttpMethod {
  final String method;
  final String path;

  const HttpMethod(this.method, this.path);
}

/// GET request
@immutable
class GET extends HttpMethod {
  const GET(String path) : super(HttpMethods.GET, path);
}

/// POST request
@immutable
class POST extends HttpMethod {
  const POST(String path) : super(HttpMethods.POST, path);
}

/// PUT request
@immutable
class PUT extends HttpMethod {
  const PUT(String path) : super(HttpMethods.PUT, path);
}

/// HEAD request
@immutable
class HEAD extends HttpMethod {
  const HEAD(String path) : super(HttpMethods.HEAD, path);
}

/// DELETE request
@immutable
class DELETE extends HttpMethod {
  const DELETE(String path) : super(HttpMethods.DELETE, path);
}

/// PATCH request
@immutable
class PATCH extends HttpMethod {
  const PATCH(String path) : super(HttpMethods.PATCH, path);
}

/// DOWNLOAD request
@immutable
class DOWNLOAD extends HttpMethod {
  const DOWNLOAD(String path) : super(HttpMethods.DOWNLOAD, path);
}

/// Header of request
@immutable
class Header {
  final String key;
  final dynamic value;

  const Header(this.key, [this.value]);
}

@immutable
class HeaderMap {
  final Map<String, dynamic> headers;

  const HeaderMap([this.headers]);
}

@immutable
class Query {
  final String key;
  final dynamic value;
  final bool encoded;

  const Query(this.key, {this.value, this.encoded = false});
}

@immutable
class QueryMap {
  final Map<String, dynamic> queries;
  final bool encoded;

  const QueryMap({this.queries, this.encoded = false});
}

@immutable
class Field {
  final String key;

  const Field(this.key);
}

@immutable
class Path {
  final String key;

  const Path(this.key);
}

@immutable
class Part {
  final String key;
  final String filename;

  const Part(this.key, [this.filename]);
}

class RawType {
  final String contentType;

  const RawType.of(this.contentType);

  static const text = RawType.of('text/plain');

  static const javaScript = RawType.of('application/javascript');

  static const json = RawType.of('application/json');

  static const html = RawType.of('text/html');

  static const xml = RawType.of('application/xml');
}

@immutable
class Raw {
  final RawType rawType;

  const Raw(this.rawType);
}

@immutable
class RawJson {
  final String key;

  const RawJson([this.key]);
}

@immutable
class Bin {
  const Bin();
}

@immutable
class ContentType {
  final String contentType;

  const ContentType([this.contentType]);
}

@immutable
class OnReceive {

  const OnReceive();
}

@immutable
class OnSend {

  const OnSend();
}
