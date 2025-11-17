import 'dart:convert' show json;
import 'dart:io';
import 'package:dio/dio.dart' as _DIO;
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../../common/exceptions/fetch_data_exception.dart';
import '../../../common/services/get_storage_service.dart';
import '../../../common/utils/app_logger.dart';
import '../../models/base/base_response.dart';
import 'api_endpoint.dart';

class APIProvider extends GetxService {
  static final _singleton = APIProvider();

  static APIProvider get instance => _singleton;

  Future<T> postRequest<T>(String url, Map<String, dynamic> data,
      {bool hasBaseResponse = true}) async {
    Map<String, String> _headers = Get.find<LocalStorageService>().headers;

    BaseOptions _postOptions = BaseOptions(
        baseUrl: APIEndpoint.apiBaseURL,
        contentType: ContentType.json.value,
        headers: _headers,
        connectTimeout: 25000,
        receiveTimeout: 25000,
        method: 'Post',
        maxRedirects: 5);

    Dio _dio = Dio(_postOptions);

    debugPrint("postRequest: ${_dio.options.baseUrl}$url");

    try {
      _DIO.Response response;

      if (data.isNotEmpty) {
        response = await _dio.post(url, data: data);
      } else {
        response = await _dio.post(url);
      }
      if (response.data is String) {
        String data = response.data;

        Map<String, dynamic> list = await json.decode(data);
        return list as T;
      }
      return _returnResponse(response, hasBaseResponse: hasBaseResponse);
    } on DioError catch (dioError) {
      debugPrint("dioError url:$url postRequest: $dioError");

      return _returnResponse(dioError.response);
    } catch (e) {
      printError(info: "getRequest: catch: $e");
      throw (FetchDataException);
    }
  }

  Future<T> getRequest<T>(String url, Map<String, dynamic>? data,
      {bool hasBaseResponse = true}) async {
    try {
      Map<String, String> _headers = Get.find<LocalStorageService>().headers;
      BaseOptions _postOptions = BaseOptions(
          baseUrl: APIEndpoint.apiBaseURL,
          contentType: ContentType.json.value,
          headers: _headers,
          connectTimeout: 25000,
          receiveTimeout: 25000,
          method: 'get',
          maxRedirects: 5);

      Dio _dio = Dio(_postOptions);
      debugPrint("getRequest: ${_dio.options.baseUrl}$url");

      _DIO.Response response;

      if (data != null && data.isNotEmpty) {
        response = await _dio.get(url, queryParameters: data);
      } else {
        response = await _dio.get(url);
      }
      if (response.data is String) {
        String data = response.data;

        Map<String, dynamic> list = await json.decode(data);
        return list as T;
      }
      return _returnResponse(response, hasBaseResponse: hasBaseResponse);
    } on DioError catch (dioError) {
      debugPrint("dioError url:$url getRequest: $dioError");

      return _returnResponse(dioError.response);
    } catch (e) {
      debugPrint("getRequest: catch: $e");
      rethrow;
    }
  }

  Future<T> getListRequest<T>(
    String url,
    Map<String, dynamic> data,
  ) async {
    Map<String, String> _headers = Get.find<LocalStorageService>().headers;
    BaseOptions _postOptions = BaseOptions(
        baseUrl: APIEndpoint.apiBaseURL,
        contentType: ContentType.json.value,
        headers: _headers,
        connectTimeout: 25000,
        receiveTimeout: 25000,
        method: 'Post',
        maxRedirects: 5);

    Dio _dio = Dio(_postOptions);
    debugPrint("getListRequest: ${_dio.options.baseUrl} $url");

    try {
      var response = await _dio.get(url, queryParameters: data);

      if (response.data is String) {
        String data = response.data;

        List list = await json.decode(data);
        return list as T;
      }
      return response.data;
    } on DioError catch (dioError) {
      debugPrint("dioError postListRequest: $dioError");
      return _returnResponse(dioError.response);
    } catch (e) {
      debugPrint("postListRequest: catch: $e");
      throw ('$e');
    }
  }

  Future<T> deleteRequest<T>(String url, Map<String, dynamic> data,
      {bool hasBaseResponse = true}) async {
    try {
      Map<String, String> _headers = Get.find<LocalStorageService>().headers;
      BaseOptions _postOptions = BaseOptions(
          baseUrl: APIEndpoint.apiBaseURL,
          contentType: ContentType.json.value,
          headers: _headers,
          connectTimeout: 25000,
          receiveTimeout: 25000,
          method: 'Post',
          maxRedirects: 5);

      Dio _dio = Dio(_postOptions);
      debugPrint("getRequest: ${_dio.options.baseUrl}$url");
      var response = await _dio.delete(url, queryParameters: data);

      if (response.data is String) {
        String data = response.data;

        Map<String, dynamic> list = await json.decode(data);
        return list as T;
      }
      return _returnResponse(response, hasBaseResponse: hasBaseResponse);
    } on DioError catch (dioError) {
      debugPrint("dioError url:$url getRequest: $dioError");
      return _returnResponse(dioError.response);
    } catch (e) {
      debugPrint("getRequest: catch: $e");
      rethrow;
    }
  }

  Future<T> putRequest<T>(String url, Map<String, dynamic> data,
      {bool hasBaseResponse = false}) async {
    Map<String, String> _headers = Get.find<LocalStorageService>().headers;
    BaseOptions _postOptions = BaseOptions(
        baseUrl: APIEndpoint.apiBaseURL,
        contentType: ContentType.json.value,
        headers: _headers,
        connectTimeout: 25000,
        receiveTimeout: 25000,
        method: 'put',
        maxRedirects: 5);

    Dio _dio = Dio(_postOptions);
    debugPrint("putRequest: ${_dio.options.baseUrl}$url");

    try {
      _DIO.Response response;

      if (data != null && data.isNotEmpty) {
        response = await _dio.put(url, data: data);
      } else {
        response = await _dio.put(url);
      }
      if (response.data is String) {
        String data = response.data;

        Map<String, dynamic> list = await json.decode(data);
        return list as T;
      }
      return _returnResponse(response, hasBaseResponse: hasBaseResponse);
    } on DioError catch (dioError) {
      debugPrint("dioError url:$url getRequest: $dioError");
      return _returnResponse(dioError.response);
    } catch (e) {
      printError(info: "getRequest: catch: $e");
      throw (FetchDataException);
    }
  }

  Future<T> uploadRequest<T>(
      String url, File file, Function(int sent, int total) progressFunc,
      {bool hasBaseResponse = true}) async {
    String fileName = file.path.split('/').last;

    _DIO.FormData data = _DIO.FormData.fromMap({
      fileName: [
        await _DIO.MultipartFile.fromFile(file.path, filename: fileName)
      ]
    });

    Map<String, String> _headers = Get.find<LocalStorageService>().headers;

    BaseOptions _postOptions = BaseOptions(
        baseUrl: APIEndpoint.uploadURL,
        contentType: ContentType.json.value,
        headers: _headers,
        connectTimeout: 25000,
        receiveTimeout: 25000,
        maxRedirects: 5,
        method: 'Post');
//***********************************************
    Dio _dio = Dio(_postOptions);
    debugPrint("uploadRequest: $fileName");
    var response = await _dio.post(
      url,
      data: data,
      onReceiveProgress: (count, total) {
        debugPrint("Received $fileName received: $count of $total");
      },
      onSendProgress: progressFunc,
    );
    debugPrint("uploadRequest: $fileName response: $response");

    try {
      if (response.data is String) {
        String data = response.data;

        var item = await json.decode(data);
        return item;
      }
      return _returnResponse(response, hasBaseResponse: true);
    } on DioError catch (dioError) {
      return _returnResponse(dioError.response);
    } catch (e) {
      debugPrint("getRequest: catch: $e");
      rethrow;
    }
  }

  dynamic _returnResponse(_DIO.Response? response,
      {bool hasBaseResponse = true}) {
    try {
      BaseResponse? result;
      try {
        if (hasBaseResponse) {
          result = BaseResponse<dynamic>.fromJson(response?.data, null);
        }
      } catch (e) {
        AppLogger.e('$e');
        rethrow;
      }
      switch (response?.statusCode) {
        case 200:
          if (hasBaseResponse) {
            if (result!.succeeded) {
              return result;
            } else {
              throw (result.messages);
            }
          } else {
            return response?.data;
          }
        case 400:
          throw "${result?.exception?.replaceAll('. [en]', '')}";
        case 401:
          throw "${result?.exception?.replaceAll('. [en]', '')}";
        case 403:
          throw "${result?.exception?.replaceAll('. [en]', '')}";
        case 404:
          throw "${result?.exception?.replaceAll('. [en]', '')}";
        case 405:
          throw "${result?.exception?.replaceAll('. [en]', '')}";
        case 500:
          throw "${result?.exception?.replaceAll('. [en]', '')}";

        default:
          throw 'خطای ارتباط با سرور\nاز خاموش بودن فیلتر شکن خود اطمینان حاصل کنید';
      }
    } catch (e) {
      printError(info: "$e");
      if(response is String){
        throw ('$response');
      }else{
        rethrow;
      }
      // else{
      //   throw
      // }
    }
  }
}
