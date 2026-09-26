import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.twistmena.com/music';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/Dlogin/sendCode'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
      }),
    );

    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/Dlogin/verify'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'phone': phone,
        'code': code,
      }),
    );

    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> getBalance({
    required Map<String, String> headers,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/user/loyalty/balance/details'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'فشل جلب الرصيد: HTTP ${response.statusCode}',
      );
    }

    return _decodeResponse(response);
  }

  Future<Map<String, dynamic>> getHistory({
    required Map<String, String> headers,
  }) async {
    final response = await _client.get(
      Uri.parse('$baseUrl/user/loyalty/history'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'فشل جلب السجل: HTTP ${response.statusCode}',
      );
    }

    return _decodeResponse(response);
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception(
        'استجابة غير صالحة من الخادم: HTTP ${response.statusCode}',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'HTTP ${response.statusCode}';

      if (decoded is Map) {
        final value =
            decoded['message'] ??
            decoded['error'] ??
            decoded['detail'];

        if (value != null) {
          message = value.toString();
        }
      }

      throw Exception(message);
    }

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
      return Map<String, dynamic>.from(decoded.first as Map);
    }

    return <String, dynamic>{
      'data': decoded,
    };
  }

  void dispose() {
    _client.close();
  }
}
