import 'package:flutter/material.dart';

import 'data_service.dart';
import '../models/lesson.dart';

class DataProvider with ChangeNotifier {
  List<Lesson>? _lessons;
  List<Lesson>? get lessons => _lessons;

  Future<void> fetchLessons() async {
    await DataService().fetchLessons();
    _lessons = DataService().lessons;
    notifyListeners();
  }
}
