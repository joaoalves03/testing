import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_service.dart';
import '../models/lesson.dart';

class DataProvider with ChangeNotifier {
  List<Lesson>? _lessons;
  List<Lesson>? get lessons => _lessons;

  String studentName = '';
  double balance = 0.00;
  late SharedPreferences prefs;
  late String serverUrl, academicosToken, sasToken, sasRefreshToken;

  Future<void> initializePreferences() async {
    prefs = await SharedPreferences.getInstance();
    serverUrl = prefs.getString('server_url')!;
    academicosToken = prefs.getString('academicos_token')!;
    sasToken = prefs.getString('sas_token')!;
    sasRefreshToken = prefs.getString('sas_refresh_token')!;

    await fetchStudentInfo();
    await getBalance();
  }

  Future<void> fetchStudentInfo() async {
    if (studentName.isEmpty) {
      final response = await DataService()
          .fetchStudentInfo(serverUrl, academicosToken, prefs);
      if (response != null) {
        studentName = response['name'].split(' ')[0];
        prefs.setInt('student_id', response['studentId']);
      }
      notifyListeners();
    }
  }

  Future<void> getBalance() async {
    if (balance == 0.00) {
      final response = await DataService()
          .fetchBalance(serverUrl, sasToken, sasRefreshToken, prefs);
      if (response != null) {
        balance = response;
      }
      notifyListeners();
    }
  }

  Future<void> fetchLessons() async {
    if (_lessons == null) {
      await DataService().fetchLessons();
      _lessons = DataService().lessons;
      notifyListeners();
    }
  }
}
