import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> loadConfig() async {
  try {
    final response = await http.get(Uri.parse('config.json'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      print('Failed to load config.json: ${response.statusCode}');
    }
  } catch (e) {
    print('An error occurred while loading config.json: $e');
  }
  return {};
}
