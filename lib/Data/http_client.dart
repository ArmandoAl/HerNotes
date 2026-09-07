import 'package:her_notes/Config/api_config.dart';
import 'package:her_notes/Data/mocks/mock_api.dart';
import 'package:http/http.dart' as http;

/// Thin wrapper around `package:http` that can be swapped for the in-app mock.
class ApiHttp {
  static Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    if (useMocks) return MockApi.get(url, headers: headers);
    return http.get(url, headers: headers);
  }

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    if (useMocks) {
      return MockApi.post(url, headers: headers, body: body);
    }
    return http.post(url, headers: headers, body: body);
  }

  static Future<http.Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    if (useMocks) {
      return MockApi.put(url, headers: headers, body: body);
    }
    return http.put(url, headers: headers, body: body);
  }
}
