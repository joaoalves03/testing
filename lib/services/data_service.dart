import 'dart:convert';
import 'dart:typed_data';
import 'package:goipvc/main.dart';
import 'package:goipvc/models/tuition_fee.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lesson.dart';
import '../models/student.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  List<Lesson>? _lessons;
  Student? _studentInfo;
  double? _balance;
  Uint8List? _studentImage;
  List<TuitionFee>? _tuitionFees;

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

  Future<void> fetchStudentInfo(
      String serverUrl, String academicosToken, SharedPreferences prefs) async {
    if (_studentInfo == null) {
      final response = await http.get(
        Uri.parse('$serverUrl/academicos/student-info'),
        headers: {
          'Cookie': academicosToken,
        },
      );

      if (response.statusCode == 200) {
        _studentInfo = Student.fromJson(jsonDecode(response.body));
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
          await fetchStudentInfo(serverUrl, json['token'], prefs);
        } else {
          logger.d('Failed to refresh token..?');
        }
      }
    }
  }

  Student? get studentInfo => _studentInfo;

  Future<void> fetchBalance(String serverUrl, String sasToken,
      String sasRefreshToken, SharedPreferences prefs) async {
    if (_balance == null) {
      final response = await http.get(
        Uri.parse('$serverUrl/sas/balance'),
        headers: {
          'Authorization': sasToken,
          'Cookie': sasRefreshToken,
        },
      );

      if (response.statusCode == 200) {
        _balance = double.parse(response.body);
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
          await fetchBalance(
              serverUrl, tokens["sas"], tokens["sasRefresh"], prefs);
        } else {
          logger.d('Failed to refresh token..?');
        }
      }
    }
  }

  double? get balance => _balance;

  Future<void> fetchStudentImage(
      String studentId, String courseId, String academicosToken) async {
    if (_studentImage == null) {
      final url =
          'https://academicos.ipvc.pt/netpa/PhotoLoader?codAluno=$studentId&codCurso=$courseId';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Cookie': academicosToken,
        },
      );

      if (response.statusCode == 200) {
        _studentImage = response.bodyBytes;
      }
    }
  }

  Uint8List? get studentImage => _studentImage;

  Future<void> fetchTuitionFees(
      String serverUrl, String academicosToken, SharedPreferences prefs) async {
    if (_tuitionFees == null) {
      final response = await http.get(
        Uri.parse('$serverUrl/academicos/tuition'),
        headers: {
          'Cookie': academicosToken,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List;
        _tuitionFees = data.map((e) => TuitionFee.fromJson(e)).toList();
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
          await fetchTuitionFees(serverUrl, json['token'], prefs);
        } else {
          logger.d('Failed to refresh token..?');
        }
      }
    }
  }

  List<TuitionFee>? get tuitionFees => _tuitionFees;
}
