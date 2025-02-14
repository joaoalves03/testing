import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Lesson>? _lessons;

  Future<void> fetchLessons() async {
    final prefs = await SharedPreferences.getInstance();
    final serverUrl = prefs.getString('server_url')!;
    final studentId = prefs.getInt('student_id')!;
    final onToken = prefs.getString('on_token')!;

    final response = await http.post(
      Uri.parse('$serverUrl/on/schedule'),
      body: 'studentId=$studentId',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': onToken,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      _lessons = data.map((e) => Lesson.fromJson(e)).toList();
    } else if (response.statusCode == 401) {
      final refreshToken = await http.post(
        Uri.parse('$serverUrl/auth/refresh-token'),
        body: jsonEncode({
          'username': prefs.getString('username')!,
          'password': prefs.getString('password')!,
          'strategy': 2,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (refreshToken.statusCode == 200) {
        var json = jsonDecode(refreshToken.body);
        await prefs.setString('on_token', json['token']);
        await fetchLessons();
      }
    }
  }

  List<Lesson>? get lessons => _lessons;
}
