import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goipvc/models/curricular_unit.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:goipvc/utils/shared_prefs.dart';

import '../main.dart';
import '../models/task.dart';
import '../providers/data_providers.dart';
import '../models/lesson.dart';
import '../models/student.dart';
import '../models/tuition_fee.dart';

class DataService {
  final Ref ref;
  DataService(this.ref);

  Future<Map<String, String>> _refreshToken(String url) async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = Uri.parse(url).origin;

    String tokenType = '';
    final username = prefs['username'] ?? '';
    final password = prefs['password'] ?? '';

    if (url.contains('on')) {
      tokenType = 'on';
    } else if (url.contains('academicos')) {
      tokenType = 'academicos';
    } else if (url.contains('moodle')) {
      tokenType = 'moodle';
    } else if (url.contains('sas')) {
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

      await SharedPrefsUtil.printPrefs();
      if (tokenType == 'sas') {
        final data = responseBody[tokenType];

        await sharedPreferences.setString('sas_token', data['token']);
        await sharedPreferences.setString(
            'sas_refresh_token', data['refreshToken']);
        prefs['sas_token'] = data['token'];
        prefs['sas_refresh_token'] = data['refreshToken'];

        return {
          'authorization': data['token'],
          'cookie': data['refreshToken'],
          'type': tokenType
        };
      } if (tokenType == 'moodle') {
        final data = responseBody[tokenType];

        await sharedPreferences.setString('moodle_cookie', data['cookie']);
        await sharedPreferences.setString(
            'moodle_sesskey', data['sesskey']);
        prefs['moodle_cookie'] = data['cookie'];
        prefs['moodle_sesskey'] = data['sesskey'];

        return {
          'cookie': data['cookie'],
          'sesskey': data['sesskey'],
          'type': tokenType
        };
      }else {
        final token = responseBody[tokenType];

        await sharedPreferences.setString('${tokenType}_token', token);
        prefs['${tokenType}_token'] = token;

        return {'cookie': token, 'type': tokenType};
      }
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

    if ((response.statusCode == 401) && retry) {
      final newToken = await _refreshToken(url);

      if (newToken['type'] == 'sas') {
        headers['Authorization'] = newToken['authorization']!;
        headers['Cookie'] = newToken['cookie']!;
      } if (newToken['type'] == 'moodle') {
        headers['Authorization'] = newToken['sesskey']!;
        headers['Cookie'] = newToken['cookie']!;
      } else {
        headers['Cookie'] = newToken['cookie']!;
      }

      return await request(method, url, headers, body: body, retry: false);
    }

    if (response.statusCode != 200 && response.statusCode != 401) {
      logger.d('$method $url');
      logger.d(response.body);
      throw Exception('Failed to load data');
    }

    return response;
  }

  Future<String?> getFirstName() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var firstName = sharedPreferences.getString('first_name');

    if (firstName != null && firstName != 'Unauthorized') {
      return firstName;
    }

    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final onToken = prefs['on_token'] ?? '';

    final response = await request(
      'GET',
      '$serverUrl/on/first-name',
      {'Cookie': onToken},
    );

    firstName = response.body;
    await sharedPreferences.setString('first_name', firstName);

    return firstName;
  }

  Future<String> getBalance() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var balance = sharedPreferences.getString('balance');

    if (balance != null) {
      return balance;
    }

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

    balance = response.body;
    await sharedPreferences.setString('balance', balance);

    return balance;
  }

  Future<int> getStudentId() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var studentId = sharedPreferences.getInt('student_id');

    if (studentId != null) {
      return studentId;
    }

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

    studentId = int.parse(response.body);
    await sharedPreferences.setInt('student_id', studentId);

    return studentId;
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

  Future<List<Task>> getTasks() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final moodleCookie = prefs['moodle_cookie'] ?? '';
    final moodleSesskey = prefs['moodle_sesskey'] ?? '';

    final response = await request(
      'GET',
      '$serverUrl/moodle/assignments',
      {
        'Authorization': moodleSesskey,
        'Cookie': moodleCookie,
      },
    );

    final data = jsonDecode(response.body) as List;
    return data.map((e) => Task.fromJson(e)).toList();
  }

  Future<Student> getStudentInfo() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final username = prefs['username'] ?? '';
    final academicosToken = prefs['academicos_token'] ?? 'JSESSIONID=...';

    final response = await request(
      'GET',
      '$serverUrl/academicos/student-info',
      {'Cookie': academicosToken},
    );

    var student = Student.fromJson(jsonDecode(response.body));
    student.email = '$username@ipvc.pt';

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (!sharedPreferences.containsKey('course_id')) {
      await sharedPreferences.setInt('course_id', student.courseId);
    }

    return student;
  }

  Future<Uint8List> getStudentImage(int studentId) async {
    final prefs = await ref.read(prefsProvider.future);
    final academicosToken = prefs['academicos_token'] ?? 'JSESSIONID=...';

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var courseId = sharedPreferences.getInt('course_id');

    final url =
        'https://academicos.ipvc.pt/netpa/PhotoLoader?codAluno=$studentId&codCurso=$courseId';
    final response = await request(
      'GET',
      url,
      {'Cookie': academicosToken},
    );

    return response.bodyBytes;
  }

  Future<CurricularUnit> getCurricularUnit(int curricularUnitId) async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final onToken = prefs['on_token'] ?? '';

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var courseId = sharedPreferences.getInt('course_id');

    final curricularUnits = await ref.read(curricularUnitsProvider.future);
    final curricularUnit = curricularUnits.firstWhere(
      (unit) => unit.id == curricularUnitId,
      orElse: () =>
          throw Exception('Curricular unit $curricularUnitId not found'),
    );

    final response = await request(
        'POST',
        '$serverUrl/on/curricular-unit',
        {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Cookie': onToken
        },
        body: 'courseId=$courseId&classId=$curricularUnitId');

    final puc = PUC.fromJson(jsonDecode(response.body));
    curricularUnit.puc = puc;

    return curricularUnit;
  }

  Future<Map<String, dynamic>> getCurricularUnits() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final academicosToken = prefs['academicos_token'] ?? '';

    final response = await request(
      'POST',
      '$serverUrl/academicos/curricular-units',
      {'Cookie': academicosToken},
    );

    final data = jsonDecode(response.body);
    List<CurricularUnit> units = [];
    final cuList = data['curricularUnits'] as List;
    units.addAll(cuList.map((e) => CurricularUnit.fromJson(e)).toList());

    return {'avgGrade': data['avgGrade'], 'curricularUnits': units};
  }

  Future<List<TuitionFee>> getTuitionFees() async {
    final prefs = await ref.read(prefsProvider.future);
    final serverUrl = prefs['server_url'] ?? '';
    final academicosToken = prefs['academicos_token'] ?? '';

    final response = await request(
      'GET',
      '$serverUrl/academicos/tuitions',
      {'Cookie': academicosToken},
    );

    final data = jsonDecode(response.body) as List;
    return data.map((e) => TuitionFee.fromJson(e)).toList();
  }
}
