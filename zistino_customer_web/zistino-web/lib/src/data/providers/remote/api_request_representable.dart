import 'api_endpoint.dart';

enum HTTPMethod { get, post, delete, put, patch }

extension HTTPMethodString on HTTPMethod {
  String get string {
    switch (this) {
      case HTTPMethod.get:
        return "get";
      case HTTPMethod.post:
        return "post";
      case HTTPMethod.delete:
        return "delete";
      case HTTPMethod.patch:
        return "patch";
      case HTTPMethod.put:
        return "put";
    }
  }
}

abstract class APIClass {
  APIControllers get controller;

}

abstract class APIRequestRepresentable {
  String get url;

  APIControllers get controller;

  Map<String, String>? get query;

  dynamic get body;

  Future request();
}
