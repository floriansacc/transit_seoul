import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:transit_seoul/controllers/public_method.dart';

import '../styles/logger.dart';

enum ApiType {
  busInfo('http://ws.bus.go.kr/api/rest'),
  metroInfo('http://swopenAPI.seoul.go.kr/api/subway/[KEY]/json'),
  kakaomap(''),
  localServer('http://localhost:4000');

  const ApiType(this.url);

  final String url;
}

class GlobalService {
  String get dataKrKey => dotenv.env['DATA_KR_API_KEY']!;
  String get metroKrKey => dotenv.env['METRO_KR_API_KEY']!;

  Future<http.Response> httpRequest(
    HttpMethod method, {
    required ApiType apiUrl,
    required String path,
    Map<String, String>? queryParameters,
    Map<String, String>? header,
    Map<String, String>? body,
  }) async {
    assert(path[0] == '/', 'path require a "/"');

    Map<String, String> apiResources = switch (apiUrl) {
      ApiType.busInfo => {
          'ServiceKey': dataKrKey,
          'resultType': 'json',
        },
      ApiType.metroInfo => {},
      ApiType.kakaomap => {},
      ApiType.localServer => {},
    };
    Map<String, String> apiHeader = switch (apiUrl) {
      ApiType.busInfo => {},
      ApiType.metroInfo => {},
      ApiType.kakaomap => {},
      ApiType.localServer => {
          'Authorization': 'Bearer ${await secureStorage.read(key: 'token')}',
        },
    };

    final Uri requestUrl = Uri.parse('${apiUrl.url.replaceAll(
      switch (apiUrl) {
        ApiType.metroInfo => '[KEY]',
        _ => '',
      },
      switch (apiUrl) {
        ApiType.metroInfo => metroKrKey,
        _ => '',
      },
    )}$path')
        .replace(
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
            ...apiHeader,
          },
        );
      case HttpMethod.post:
        response = await http.post(
          requestUrl,
          headers: {
            ...header ?? {},
            ...apiHeader,
          },
          body: jsonEncode({...body ?? {}}),
        );
    }

    if (kDebugMode) {
      String logMessage = 'Response.$method << $requestUrl\n'
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
