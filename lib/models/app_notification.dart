import 'package:flutter/material.dart';

class AppNotification {
  final String type;
  final IconData? icon;
  final String title;
  final String? subtitle;
  final DateTime timestamp;
  final String? topText;

  AppNotification({
    this.icon,
    required this.type,
    this.topText,
    required this.title,
    this.subtitle,
    required this.timestamp,
  });
}
