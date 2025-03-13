import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Task {
  Task({
    required this.id,
    required this.title,
    required this.due,
    required this.icon,
    required this.overdue,
    required this.url,
    required this.submissionURL,
    required this.type,
    required this.curricularUnitId,
    required this.curricularUnitName,
  });

  int id;
  String title;
  String due;
  IconData icon;
  String type;
  bool overdue;
  String url;
  String submissionURL;
  int curricularUnitId;
  String? curricularUnitName;

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['activityname'],
      due: convertTimestamp(json['timeusermidnight']),
      icon: getIcon(json['modulename']),
      type: json['modulename'],
      overdue: json['overdue'],
      url: json['url'],
      submissionURL: json['action']['url'],
      curricularUnitId: int.parse(json['course']['idnumber'].split("-")[3]),
      curricularUnitName: json['course']['fullname'],
    );
  }

  static String convertTimestamp(int timestamp){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('yyyy-MM-ddTHH:mm:ss').format(dateTime);
  }

  static IconData getIcon(String type){
    switch(type){
      case 'questionnaire':
        return Icons.format_list_bulleted_rounded;
      default:
        return Icons.upload_file_rounded;
    }
  }
}
