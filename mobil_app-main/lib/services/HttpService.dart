import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  static const _base =
      'http://10.10.208.123:8080/web'; //'http://10.10.208.181:8080/web';

  static Future<http.Response> get(String endpoint) async {
    return await http.get(Uri.parse(_base));
  }

  static Future<http.Response> post(String endpoint, Object? body) async {
    return await http.post(Uri.parse(_base),
        body: jsonEncode(body),
        headers: <String, String>{
          "Content-Type": "application/json",
        });
  }
}
