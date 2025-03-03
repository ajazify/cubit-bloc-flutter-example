import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiProvider {
  final String parseUrl;

  ApiProvider({required this.parseUrl});

  Future<http.Response> get({Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(parseUrl), headers: headers);
    return response;
  }

  Future<http.Response> post(Map<String, dynamic> body, {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse(parseUrl),
      headers: headers ?? {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }
}
