import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiTokenService {
  final String baseUrl;

  ApiTokenService({required this.baseUrl});

  Future<String?> getCustomToken(String uid) async {
    final Uri url = Uri.parse('$baseUrl/getCustomToken');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'uid': uid}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['token'];
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
