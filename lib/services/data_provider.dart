import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:goipvc/models/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data_service.dart';
import '../models/lesson.dart';

class DataProvider with ChangeNotifier {
  List<Lesson>? _lessons;
  List<Lesson>? get lessons => _lessons;

  Student? get studentInfo => DataService().studentInfo;
  double get balance => DataService().balance ?? 0.00;
  Uint8List? get studentImage => DataService().studentImage;
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
    await fetchStudentImage();
  }

  Future<void> fetchLessons() async {
    if (_lessons == null) {
      await DataService().fetchLessons();
      _lessons = DataService().lessons;
      notifyListeners();
    }
  }

  Future<void> fetchStudentInfo() async {
    if (DataService().studentInfo == null) {
      await DataService().fetchStudentInfo(serverUrl, academicosToken, prefs);
      if (DataService().studentInfo != null) {
        prefs.setInt('student_id', DataService().studentInfo!.studentId);
      }
      notifyListeners();
    }
  }

  Future<void> getBalance() async {
    if (DataService().balance == null) {
      await DataService()
          .fetchBalance(serverUrl, sasToken, sasRefreshToken, prefs);
      notifyListeners();
    }
  }

  Future<void> fetchStudentImage() async {
    if (DataService().studentInfo != null &&
        DataService().studentImage == null) {
      await DataService().fetchStudentImage(
        DataService().studentInfo!.studentId.toString(),
        DataService().studentInfo!.courseId.toString(),
        academicosToken,
      );
      notifyListeners();
    }
  }
}
