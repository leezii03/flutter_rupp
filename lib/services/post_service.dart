import 'dart:convert';

import 'package:flutter_assignment/services/api_config.dart';
import 'package:http/http.dart' as http;

class PostService {
  static Future<List<dynamic>> getAllPosts() async {
    final url = Uri.parse("${ApiConfig.baseUrl}/api/v1/Upload/getAll");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load posts");
    }
  }
}
