import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://lapsafe.onrender.com';

  final Map<String, String> headers = {'Content-Type': 'application/json'};

  /// LOGIN
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: headers,
      body: jsonEncode({'username': username, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['message']);
    }

    return data; // contains user_id
  }

  /// SIGNUP
  Future<void> signup(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: headers,
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode != 201) {
      final data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  /// GET REPORTS (by user_id)
  Future<List<List<dynamic>>> getReports(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/get_reports/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      return [];
    }

    final decoded = jsonDecode(response.body);
    return List<List<dynamic>>.from(
      decoded['reports'].map((e) => List<dynamic>.from(e)),
    );
  }


  /// PROCESS TEXT
  Future<String> processText({
    required String text,
    required String userId,
    List<String> modes = const [],
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/process_content/process_text'),
      headers: headers,
      body: jsonEncode({'text': text, 'user_id': userId, 'modes': modes}),
    );

    final data = jsonDecode(response.body);
    return data['status'];
  }
}
