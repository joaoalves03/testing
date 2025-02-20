import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../providers/data_providers.dart';
import '../models/lesson.dart';
import '../models/student.dart';
import '../models/tuition_fee.dart';

class DataService {
  final Ref ref;
  DataService(this.ref);

  Future<void> _refreshToken(String url) async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = Uri.parse(url).origin;

    String tokenType = '';
    final username = prefs['username'] ?? '';
    final password = prefs['password'] ?? '';

    if (url.contains("on")) {
      tokenType = 'on';
    } else if (url.contains("academicos")) {
      tokenType = 'academicos';
    } else if (url.contains("moodle")) {
      tokenType = 'moodle';
    } else if (url.contains("sas")) {
      tokenType = 'sas';
    }

    final response = await http.post(
      Uri.parse('$serverUrl/auth'),
      body: {
        'username': username,
        'password': password,
        tokenType: 'true',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      if (tokenType == 'sas') {
        final token = responseBody[tokenType]['token'];
        final refreshToken = responseBody[tokenType]['refreshToken'];

        await sharedPreferences.setString('sas_token', token);
        await sharedPreferences.setString('sas_refresh_token', refreshToken);
      } else {
        final token = responseBody[tokenType];
        await sharedPreferences.setString('${tokenType}_token', token);
      }
      logger.d('Token refreshed: $tokenType');
    } else {
      throw Exception('Failed to refresh $tokenType token');
    }
  }

  Future<http.Response> request(
      String method, String url, Map<String, String> headers,
      {String? body, bool retry = true}) async {
    final response = await (method == 'GET'
        ? http.get(Uri.parse(url), headers: headers)
        : http.post(Uri.parse(url), headers: headers, body: body));

    if (response.statusCode == 401 && retry) {
      await _refreshToken(url);
      return await request(method, url, headers, body: body, retry: false);
    }

    if (response.statusCode != 200 && response.statusCode != 401) {
      logger.d('$method $url');
      logger.d(response.body);
      throw Exception('Failed to load data');
    }

    return response;
  }

  Future<String> getFirstName() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final onToken = prefs['on_token'] ?? '';

    final response = await request(
      'GET',
      '$serverUrl/on/first-name',
      {'Cookie': onToken},
    );

    return response.body;
  }

  Future<double> getBalance() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final sasToken = prefs['sas_token'] ?? '';
    final sasRefreshToken = prefs['sas_refresh_token'] ?? '';

    final response = await request(
      'GET',
      '$serverUrl/sas/balance',
      {
        'Authorization': sasToken,
        'Cookie': sasRefreshToken,
      },
    );

    return double.parse(response.body);
  }

  Future<int> getStudentId() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final sasToken = prefs['sas_token'] ?? '';
    final sasRefreshToken = prefs['sas_refresh_token'] ?? '';

    final response = await request(
      'GET',
      '$serverUrl/sas/student-id',
      {
        'Authorization': sasToken,
        'Cookie': sasRefreshToken,
      },
    );

    return int.parse(response.body);
  }

  Future<List<Lesson>> getLessons(int studentId) async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final onToken = prefs['on_token'] ?? '';

    final response = await request(
      'POST',
      '$serverUrl/on/schedule',
      {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Cookie': onToken,
      },
      body: 'studentId=$studentId',
    );

    final data = jsonDecode(response.body) as List;
    return data.map((e) => Lesson.fromJson(e)).toList();
  }

  Future<Student> getStudentInfo() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final academicosToken = prefs['academicos_token'] ?? 'JSESSIONID=...';

    final response = await request(
      'GET',
      '$serverUrl/academicos/student-info',
      {'Cookie': academicosToken},
    );

    return Student.fromJson(jsonDecode(response.body));
  }

  Future<Uint8List> getStudentImage(int studentId, int courseId) async {
    final prefs = await ref.read(prefsProvider.future);
    final academicosToken = prefs['academicos_token'] ?? 'JSESSIONID=...';

    final url =
        'https://academicos.ipvc.pt/netpa/PhotoLoader?codAluno=$studentId&codCurso=$courseId';
    final response = await request(
      'GET',
      url,
      {'Cookie': academicosToken},
    );

    return response.bodyBytes;
  }

  Future<List<TuitionFee>> getTuitionFees() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final academicosToken = prefs['academicos_token'] ?? '';

    final response = await request(
      'GET',
      '$serverUrl/academicos/tuition',
      {'Cookie': academicosToken},
    );

    final data = jsonDecode(response.body) as List;
    return data.map((e) => TuitionFee.fromJson(e)).toList();
  }
}
