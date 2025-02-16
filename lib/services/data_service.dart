import 'dart:convert';
import 'dart:typed_data';
import 'package:goipvc/main.dart';
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
        // await fetchLessons();
      }
    }
  }

  List<Lesson>? get lessons => _lessons;

  Future<Map<String, dynamic>?> fetchStudentInfo(
      String serverUrl, String academicosToken, SharedPreferences prefs) async {
    final response = await http.get(
      Uri.parse('$serverUrl/academicos/student-info'),
      headers: {
        'Cookie': academicosToken,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      final refreshToken = await http.post(
        Uri.parse('$serverUrl/auth/refresh-token'),
        body: jsonEncode({
          'username': prefs.getString('username')!,
          'password': prefs.getString('password')!,
          'strategy': 0,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (refreshToken.statusCode == 200) {
        var json = jsonDecode(refreshToken.body);
        prefs.setString('academicos_token', json['token']);
        return await fetchStudentInfo(serverUrl, json['token'], prefs);
      } else {
        logger.d('Failed to refresh token..?');
      }
    }
    return null;
  }

  Future<double?> fetchBalance(String serverUrl, String sasToken,
      String sasRefreshToken, SharedPreferences prefs) async {
    final response = await http.get(
      Uri.parse('$serverUrl/sas/balance'),
      headers: {
        'Authorization': sasToken,
        'Cookie': sasRefreshToken,
      },
    );

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else if (response.statusCode == 401) {
      final refreshToken = await http.post(
        Uri.parse('$serverUrl/auth/refresh-token'),
        body: jsonEncode({
          'username': prefs.getString('username')!,
          'password': prefs.getString('password')!,
          'strategy': 3,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (refreshToken.statusCode == 200) {
        var tokens = jsonDecode(refreshToken.body)['tokens'];
        prefs.setString('sas_token', tokens["sas"]);
        prefs.setString('sas_refresh_token', tokens["sasRefresh"]);
        return await fetchBalance(
            serverUrl, tokens["sas"], tokens["sasRefresh"], prefs);
      } else {
        logger.d('Failed to refresh token..?');
      }
    }
    return null;
  }

  Future<Uint8List?> fetchStudentImage(
      String studentId, String courseId, String academicosToken) async {
    final url =
        'https://academicos.ipvc.pt/netpa/PhotoLoader?codAluno=$studentId&codCurso=$courseId';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Cookie': academicosToken,
      },
    );

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }
}
