import 'package:flutter/material.dart';

/// Data model representing an onboarding value proposition item.
class ValuePropModel {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const ValuePropModel({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
      };

  factory ValuePropModel.fromJson(
    Map<String, dynamic> json, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) {
    return ValuePropModel(
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
    );
  }
}
