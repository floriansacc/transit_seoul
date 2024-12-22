import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../styles/logger.dart';

enum ApiType {
  bus('http://ws.bus.go.kr/api/rest'),
  kakaomap('');

  const ApiType(this.url);

  final String url;
}

class GlobalService {
  String get dataKrKey => dotenv.env['DATA_KR_API_KEY']!;

  Future<http.Response> httpRequest(
    HttpMethod method, {
    required ApiType apiUrl,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? header,
  }) async {
    assert(path[0] == '/', 'path require a "/"');

    Map<String, String> apiResources = switch (apiUrl) {
      ApiType.bus => {
          'ServiceKey': dataKrKey,
          'resultType': 'json',
        },
      ApiType.kakaomap => {},
    };

    final Uri requestUrl = Uri.parse('${apiUrl.url}$path').replace(
      queryParameters: {
        ...apiResources,
        ...queryParameters ?? {},
      },
    );

    late http.Response response;

    switch (method) {
      case HttpMethod.get:
        response = await http.get(
          requestUrl,
          headers: {
            ...header ?? {},
          },
        );
      case HttpMethod.post:
        response = await http.post(
          requestUrl,
          headers: {
            ...header ?? {},
          },
        );
    }

    if (kDebugMode) {
      String logMessage = 'Response.get << $requestUrl\n'
          'Response.Code:${response.statusCode}\n'
          '---------------------------------------------------';

      // logMessage += '\nRequest.Body:$encodedBody';
      // logMessage += '\nResponse.Body:${response.body}\n'
      //     '---------------------------------------------------';

      logger.d(logMessage);
    }

    return response;
  }
}

enum HttpMethod { get, post }
