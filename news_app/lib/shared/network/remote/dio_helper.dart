import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://newsapi.org/",
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response> getNews({
    required url,
    required Map<String, dynamic> query,
  }) async {
    // 8d53935190a64f67ba4a144d8b7fc405
    // cf507a8442ce46d2866402c3e1a09328
    query["apiKey"] = "cf507a8442ce46d2866402c3e1a09328";
    return await dio.get(url, queryParameters: query);
  }
}
