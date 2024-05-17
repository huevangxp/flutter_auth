import 'dart:convert';
import 'package:http/http.dart' as http;

class userService {
  static const baseUrl = 'http://localhost:7000/api';

  static Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<void> createUser(String username, String phone, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create user');
    }
  }
}
